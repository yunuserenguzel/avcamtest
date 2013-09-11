//
//  SonickleRecorderViewController.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 9/8/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SonickleMediaManager.h"

@interface SonickleRecorderViewController : UIViewController <SonickleMediaProtocol>

@property SonickleMediaManager* mediaManager;

@end
