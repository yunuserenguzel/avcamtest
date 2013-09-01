//
//  SonicklePlayerViewController.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "SonicklePlayerViewController.h"

@interface SonicklePlayerViewController ()

@end

@implementation SonicklePlayerViewController
{
    AVAudioPlayer *audioPlayer;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setSonickle:(Sonickle *)sonickle
{
    _sonickle = sonickle;
    audioPlayer = [[AVAudioPlayer alloc] initWithData:self.sonickle.sound error:nil];
    [audioPlayer setVolume:1.0];
    audioPlayer.delegate = self;
    if([self isViewLoaded]){
        [self configureViews];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.view addSubview:self.imageView];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio)];
    [self.view addGestureRecognizer:tapGesture];

    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeGesture];
    
    if(self.sonickle != nil){
        [self configureViews];
    }
}

- (void) goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) playAudio
{
    if (self.sonickle != nil){
        
        if([audioPlayer isPlaying]){
            [audioPlayer pause];
        }
        else {
            [audioPlayer play];
        }
    }
}

- (void) configureViews
{
    [self.imageView setImage:self.sonickle.image];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
