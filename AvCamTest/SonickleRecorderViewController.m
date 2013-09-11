//
//  SonickleRecorderViewController.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 9/8/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "SonickleRecorderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TypeDefs.h"
#import "SonicklePreviewViewController.h"

@interface SonickleRecorderViewController ()

@property UIImageView* maskView;
@property UIView* cameraView;
@property UIImageView* camMicBar;
@property UIActivityIndicatorView* activityIndicator;
@property UITapGestureRecognizer* tapRecognizer;
@end

@implementation SonickleRecorderViewController
{
    NSInteger tapIndex;
    UIImage* capturedImage;
    NSData* capturedAudio;
}
- (CGRect) cameraViewFrame
{
//    return CGRectMake(0.0, -1.0 + self.navigationBar.frame.size.height, 320.0, 426.0);
    return CGRectMake(0.0, -1.0 , 320.0, 426.0);
}
- (CGRect) visibleRectFrame
{
    return CGRectMake(7.0, 50.0, 306.0, 306.0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    tapIndex = 0;

    [self.view setBackgroundColor:[UIColor grayColor]];
    self.cameraView = [[UIView alloc] initWithFrame:[self cameraViewFrame]];
    [self.view addSubview:self.cameraView];
//    [self.view insertSubview:self.cameraView belowSubview:self.navigationBar];
    [self.view addSubview:self.cameraView ];
    [[[NSThread alloc] initWithTarget:self selector:@selector(initializeMediaManager) object:nil] start];

    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedToScreen)];
    [self.view addGestureRecognizer:self.tapRecognizer];

    [self initializeMaskView];
    [self initializeCamMicBar];
    [self initializeActivityIndicator];
    
}

- (void) tappedToScreen
{
    if(tapIndex % 2 == 0){
        [self.mediaManager startAuidoRecording];
    }
    else if(tapIndex % 2 == 1){
        [self performSelector:@selector(takePicture) withObject:nil afterDelay:0.5];
        [self.mediaManager stopAudioRecording];
        [self previewSonickle];
    }
    tapIndex++;
    tapIndex = tapIndex % 2;
}

- (void) previewSonickle
{
    if(capturedImage != nil && capturedAudio != nil){
        [self performSegueWithIdentifier:PreviewSonickleSegue sender:self];
    }
}

- (void) takePicture
{
    [self.activityIndicator startAnimating];
    [self.tapRecognizer setEnabled:NO];
    [self.mediaManager takePictureWithCompletionBlock:^(UIImage *image) {
        CGFloat xScale = image.size.width / [self cameraViewFrame].size.width;
        CGFloat yScale = image.size.height / [self cameraViewFrame].size.height;
        CGFloat x = [self visibleRectFrame].origin.x * xScale;
        CGFloat y = [self visibleRectFrame].origin.y * yScale;
        CGFloat w = [self visibleRectFrame].size.width * xScale;
        CGFloat h = [self visibleRectFrame].size.height * yScale;
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        capturedImage = [image cropForRect:CGRectMake(x, y, w, h)];
        
        UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);
        capturedImage = [capturedImage imageByScalingAndCroppingForSize:CGSizeMake(612.0, 612.0)];
        
        UIImageWriteToSavedPhotosAlbum(capturedImage, nil, nil, nil);
        
        [self.activityIndicator stopAnimating];
        [self.tapRecognizer setEnabled:YES];
        [self previewSonickle];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.mediaManager startCamera];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mediaManager stopCamera];
}

- (void) initializeMediaManager
{
    self.mediaManager = [[SonickleMediaManager alloc] initWithView:self.cameraView];
    [self.mediaManager setDelegate:self];
}

- (void) initializeCamMicBar
{
    self.camMicBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cam_mic_bar.png"]];
//    self.camMicBar.frame = CGRectMake(0.0, self.view.frame.size.height - self.toolbar.frame.size.height - 60.0, 320.0, 60.0);
//    [self.view insertSubview:self.camMicBar belowSubview:self.toolbar];
    
    self.camMicBar.frame = CGRectMake(0.0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - self.navigationController.navigationBar.frame.size.height - 60.0, 320.0, 60.0);
    [self.view addSubview:self.camMicBar];
}

- (void) initializeActivityIndicator
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = [self visibleRectFrame];
    [self.maskView addSubview:self.activityIndicator];
}

- (void) initializeMaskView
{
    self.maskView = [UIImageView new];
    [self.maskView setFrame:[self cameraViewFrame]];
    [self.maskView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.maskView];

    // Ensure it's auto-resolution
    // w x h, transparent, and with device's default scaling (required for retina!)

    UIGraphicsBeginImageContextWithOptions(self.maskView.frame.size, NO, 2.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.6);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, self.maskView.frame.size.width, self.maskView.frame.size.height));
    
//    CGRect inRectFrame = CGRectMake(7.0, 50.0, 306.0, 306.0);
    CGContextClearRect(context, [self visibleRectFrame]);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 0.2);
    CGContextStrokeRect(context, [self visibleRectFrame]);
    
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    [self.maskView setImage:maskImage];
    
}

-(void)manager:(SonickleMediaManager *)manager audioDataReady:(NSData *)data
{
    capturedAudio = data;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SonicklePreviewViewController class]]){
        Sonickle* sonickle = [[Sonickle alloc] initWithImage:capturedImage
                                                    andSound:capturedAudio
                                                      withId:[NSString stringWithFormat:@"sonickle%f",[NSDate timeIntervalSinceReferenceDate]]];
        SonicklePreviewViewController* previewController = segue.destinationViewController;
        [previewController setSonickle:sonickle];
        capturedAudio = nil;
        capturedImage = nil;
        tapIndex = 0;
    }
}

@end
