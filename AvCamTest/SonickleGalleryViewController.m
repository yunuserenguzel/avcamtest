//
//  SonickleGalleryViewController.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "SonickleGalleryViewController.h"
#import "Sonickle.h"
#import "SonicklePlayerViewController.h"

@interface SonickleThumbail : UIImageView

- (id) initWithSonickle:(Sonickle*)sonickle;

@property Sonickle* sonickle;

@end

@implementation SonickleThumbail

- (id)initWithSonickle:(Sonickle *)sonickle
{
    if(self = [super init]){
        self.sonickle = sonickle;
        self.image = sonickle.image;
    }
    return self;
}

@end


@interface SonickleGalleryViewController ()

@end

@implementation SonickleGalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CGSize) thumbnailSize
{
    return CGSizeMake(96.0, 144.0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeGesture];
    
    
    NSArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:SonicklesUserDefaultsKey];
    for (int i=0; i < array.count; i++) {
        NSString* fileName = [array objectAtIndex:i];
        Sonickle* sonickle = [Sonickle sonickleFromDictionary:[NSDictionary dictionaryWithContentsOfFile:fileName]];
        SonickleThumbail* thumbnail = [[SonickleThumbail alloc] initWithSonickle:sonickle];
        [thumbnail setFrame:CGRectMake((i%3) * [self thumbnailSize].width, (i/3) * [self thumbnailSize].height, [self thumbnailSize].width, [self thumbnailSize].height)];
        [self.view addSubview:thumbnail];
        thumbnail.tag = i;
        
        [thumbnail setUserInteractionEnabled:YES];
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openSonickle:)];
        [thumbnail addGestureRecognizer:gesture];
    }
    
}

- (void) goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) openSonickle:(UIGestureRecognizer*)gesture
{
    SonickleThumbail* thumbail = (SonickleThumbail*)gesture.view;
    SonicklePlayerViewController* player = [[SonicklePlayerViewController alloc] init];
    [player setSonickle:thumbail.sonickle];
    [self presentViewController:player animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
