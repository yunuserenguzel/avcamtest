//
//  SonicklePlayerViewController.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import "Sonickle.h"

@interface SonicklePlayerViewController : UIViewController <AVAudioPlayerDelegate,UIScrollViewDelegate>

@property (nonatomic) Sonickle* sonickle;
@property UIScrollView* scrollView;
@property UIImageView* imageView;

@end
