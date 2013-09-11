//
//  ViewController.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/24/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+scaleToSize.h"
#import "Sonickle.h"
#import "SonicklePlayerViewController.h"
#import "SonickleGalleryViewController.h"
#import "SonickleRecorderViewController.h"


typedef void (^ Block)();

@interface ViewController () 

@end

@implementation ViewController
{
    UIView* cameraView;
    UIImageView* imageView;
    UIActivityIndicatorView* activityIndicator;
    NSInteger tapIndex;
    Sonickle* lastCreatedSonickle;
    UIImage* lastCapturedImage;
    NSData* lastRecordedAuido;
}

- (void)manager:(SonickleMediaManager *)manager audioDataReady:(NSData *)data
{
    NSLog(@"ViewController: auido data is ready from manager");
    lastRecordedAuido = data;
//    lastCreatedSonickle = [Sonickle sonickleWithImage:image andSound:data withId:[NSString stringWithFormat:@"sonickle%f",[NSDate timeIntervalSinceReferenceDate]]];
//    
//    [lastCreatedSonickle saveToFile];
    
//    [self NSThreadedBlock:^{
//        SonicklePlayerViewController* player = [[SonicklePlayerViewController alloc] init];
//        [player setSonickle:lastCreatedSonickle];
//        [self presentViewController:player animated:YES completion:nil];
//    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tapIndex = 0;
    
    lastCreatedSonickle = nil;
    
    cameraView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:cameraView];
    self.sonickleMediaManager = [[SonickleMediaManager alloc] initWithView:cameraView];
    [self.sonickleMediaManager setDelegate:self];
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedToScreen)];
    
    [self.view addGestureRecognizer:tapRecognizer];
    
    imageView = [[UIImageView alloc] init];
    [imageView setFrame:self.view.frame];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    UITapGestureRecognizer* doubleTouchTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveToCameraRoll)];
    [doubleTouchTapRecognizer setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:doubleTouchTapRecognizer];
    [self.view addSubview:imageView];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
    [button setTitle:@"Gallery" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openGallery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(self.view.frame.size.width - 100.0, 0.0, 100.0, 44.0)];
    [button setTitle:@"Record" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openRecorder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setFrame:self.view.frame];
    [self.view addSubview:activityIndicator];
    
}

- (void) openRecorder
{
    [self presentViewController:[[SonickleRecorderViewController alloc] init] animated:YES completion:nil];
}


- (void) openGallery
{
    [self presentViewController:[[SonickleGalleryViewController alloc] init] animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.sonickleMediaManager startCamera];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.sonickleMediaManager stopCamera];
}


- (void) tappedToScreen
{
    if(tapIndex % 3 == 0){
        [self.sonickleMediaManager startAuidoRecording];
    }
    else if(tapIndex % 3 == 1){
        [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.5];
        [self.sonickleMediaManager stopAudioRecording];
    }
    else if(tapIndex % 3 == 2){
        [UIView animateWithDuration:0.5 animations:^{
            imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            imageView.alpha = 0.0;
        }];
        [self.sonickleMediaManager stopAudioRecording];
        [self NSThreadedBlock:^{
            [self.sonickleMediaManager stopCamera];
        }];
    }
    tapIndex++;
    tapIndex = tapIndex % 3;
}


- (void) takePicture
{
    [activityIndicator startAnimating];
    [self.sonickleMediaManager takePictureWithCompletionBlock:^(UIImage *image) {
        lastCapturedImage = image;
        imageView.image = image;
        [activityIndicator stopAnimating];
    }];
//    AVCaptureConnection *videoConnection = nil;
//    [activityIndicator startAnimating];
//    for (AVCaptureConnection *connection in stillImageOutput.connections) {
//        for (AVCaptureInputPort *port in [connection inputPorts]) {
//            if ([[port mediaType] isEqualToString:AVMediaTypeVideo] ) {
//                videoConnection = connection;
//                break;
//            }
//        }
//        if (videoConnection) { break; }
//    }
//    
//    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
//                                                  completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
//     {
//         if(error == nil){
//             [session stopRunning];
//             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
//             image = [UIImage imageWithData:imageData];
//             NSLog(@"w:%f, h:%f",image.size.width,image.size.height);
//             NSLog(@"input file: %@ outputfile:%@",[self tempSoundFileUrl].path,[self tempConvertedSoundFileUrl].path);
//             
//             [@"" writeToFile:[self tempConvertedSoundFileUrl].path atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil ];
//             MP3Converter *mp3Converter = [[MP3Converter alloc] initWithPreset:PRESET_CD]; mp3Converter.delegate = self;
//             [mp3Converter initializeLame];
//             [mp3Converter convertMP3WithFilePath:[self tempSoundFileUrl].path outputName:TempConvertedSoundFileName];
//             
//             
//         }
//     }];
}

- (void) NSThreadedBlock:(Block)block
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(_NSThreadedBlockCallei:) object:block] start];
}

- (void) _NSThreadedBlockCallei:(Block)block
{
    block();
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
    // Dispose of any resources that can be recreated.  
}



//
//
//- (void)convertAudio
//{
//    OSStatus error = DoConvertFile(sourceURL, destinationURL, outputFormat, sampleRate);
//}
//
//- (CFURLRef) sourceSoundFileUrl
//{
//    NSString* source = [self tempSoundFileUrl].path;
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
//}
//
//- (CFURLRef) convertedSoundFileUrl
//{
//    NSString* source = [self tempConvertedSoundFileUrl].path;
//    sourceURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)source, kCFURLPOSIXPathStyle, false);
//}


@end
