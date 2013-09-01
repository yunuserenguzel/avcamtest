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

#define TempSoundFileName @"sound.caf"
#define TempConvertedSoundFileName @"converted_sound.caf"
/*
 http://www.tekritisoftware.com/convert-caf-to-mp3-in-iOS
 http://lame.sourceforge.net/
 */

typedef void (^ Block)();

@interface ViewController () 

@end

@implementation ViewController
{
    AVCaptureSession* session;
    AVCaptureDevice* device;
    UIView* cameraView;
    AVCaptureStillImageOutput* stillImageOutput;
    UIImageView* imageView;
    UIActivityIndicatorView* activityIndicator;
    
    AVAudioRecorder *audioRecorder;
    
    NSInteger tapIndex;
    
    Sonickle* lastCreatedSonickle;
    
    CFURLRef sourceURL;
    CFURLRef destinationURL;
    OSType   outputFormat;
    Float64  sampleRate;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tapIndex = 0;
    
    lastCreatedSonickle = nil;
    
    [self initializeCamera];
    [self initializeAudio];
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
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setFrame:self.view.frame];
    [self.view addSubview:activityIndicator];
    
}



- (void) openGallery
{
    [self presentViewController:[[SonickleGalleryViewController alloc] init] animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[[NSThread alloc] initWithTarget:session selector:@selector(startRunning) object:nil] start];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [session stopRunning];
}

- (NSURL*) tempConvertedSoundFileUrl
{
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:TempConvertedSoundFileName];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    return soundFileURL;
}

- (NSURL*) tempSoundFileUrl
{
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:TempSoundFileName];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    return soundFileURL;
}

- (void) initializeAudio
{
    
    NSDictionary *recordSettings = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityHigh],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:64],
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2],
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0],
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:[self tempSoundFileUrl]
                     settings:recordSettings
                     error:&error];
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [audioRecorder prepareToRecord];
    }
}

- (void) saveToCameraRoll
{
    if(imageView.image != nil){
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    }
}


- (void) tappedToScreen
{
    if(tapIndex % 3 == 0){
        [self recordAudio];
    }
    else if(tapIndex % 3 == 1){
        [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.5];
        [self stop];
    }
    else if(tapIndex % 3 == 2){
        [UIView animateWithDuration:0.5 animations:^{
            imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            imageView.alpha = 0.0;
        }];
        [self stop];
        [self NSThreadedBlock:^{
            [session startRunning]; 
        }];
    }
    tapIndex++;
    tapIndex = tapIndex % 3;
}


- (void) takePicture
{
    AVCaptureConnection *videoConnection = nil;
    [activityIndicator startAnimating];
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqualToString:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if(error == nil){
             [session stopRunning];
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage* image = [UIImage imageWithData:imageData];
             NSLog(@"w:%f, h:%f",image.size.width,image.size.height);
             
             NSData* soundData = [NSData dataWithContentsOfURL:[self tempSoundFileUrl]];
             
             image = [image imageByScalingAndCroppingForSize:CGSizeMake(600.0, 800.0)];
             
             lastCreatedSonickle = [Sonickle sonickleWithImage:image andSound:soundData withId:[NSString stringWithFormat:@"sonickle%f",[NSDate timeIntervalSinceReferenceDate]]];
             
             [lastCreatedSonickle saveToFile];
             
             [self NSThreadedBlock:^{
                 [activityIndicator stopAnimating];
                 SonicklePlayerViewController* player = [[SonicklePlayerViewController alloc] init];
                 [player setSonickle:lastCreatedSonickle];
                 [self presentViewController:player animated:YES completion:nil];
             }];
         }
     }];
}

- (void) NSThreadedBlock:(Block)block
{
    [[[NSThread alloc] initWithTarget:self selector:@selector(_NSThreadedBlockCallei:) object:block] start];
}

- (void) _NSThreadedBlockCallei:(Block)block
{
    block();
}

- (void) initializeCamera
{
    cameraView = [[UIView alloc] initWithFrame:self.view.frame];
    [cameraView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:cameraView];
    
    
    session = [[AVCaptureSession alloc] init];
    device = [[AVCaptureDevice devices] objectAtIndex:0];
    
    session.sessionPreset = AVCaptureSessionPresetPhoto;

    AVCaptureDeviceInput *captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
    
    if ([session canAddInput:captureDeviceInput]) {
        [session addInput:captureDeviceInput];
    }
    else {
        // Handle the failure.
    }
    
    AVCaptureDeviceInput* audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[[AVCaptureDevice devices] objectAtIndex:2] error:nil];
    if ([session canAddInput:audioInput]) {
        [session addInput:audioInput];
    }
    else {
        // Handle the failure.
    }
    [session startRunning];
    
    AVCaptureVideoPreviewLayer* layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [layer setFrame:CGRectMake(0.0, 0.0, cameraView.frame.size.width, cameraView.frame.size.height)];
    
    [cameraView.layer addSublayer:layer];

    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [session addOutput:stillImageOutput];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
    // Dispose of any resources that can be recreated.  
}


-(void) recordAudio
{
    if (!audioRecorder.recording) {
        [audioRecorder record];
        NSLog(@"start audio recording..");
    }
}
-(void)stop
{
    if (audioRecorder.recording) {
        [audioRecorder stop];
        NSLog(@"stop audio recording..");
    }
//    else if (audioPlayer.playing) {
//        [audioPlayer stop];
//    }
}


-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}
-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}
-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag

{
    
    NSLog(@"record finish %d",flag);
}
-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
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
