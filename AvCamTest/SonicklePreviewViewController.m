//
//  SonicklePreviewViewController.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 9/9/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "SonicklePreviewViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SonicklePreviewViewController ()

@property UIImageView* imageView;
@property UIButton* saveButton;

@end

@implementation SonicklePreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0 + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.width)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.imageView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    [self.imageView.layer setShadowOpacity:0.5];
    [self.imageView.layer setShadowRadius:5.0];
    [self.view addSubview:self.imageView];
    
    if(self.sonickle != nil){
        [self configureViews];
    }
}

- (void) configureViews
{
    [self.imageView setImage:self.sonickle.image];
}

- (void)setSonickle:(Sonickle *)sonickle
{
    _sonickle = sonickle;
    if([self isViewLoaded]){
        [self configureViews];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
