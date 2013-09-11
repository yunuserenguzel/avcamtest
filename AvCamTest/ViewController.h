//
//  ViewController.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/24/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SonickleMediaManager.h"

@interface ViewController : UIViewController <SonickleMediaProtocol>

@property SonickleMediaManager* sonickleMediaManager;

@end
