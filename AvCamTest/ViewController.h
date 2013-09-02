//
//  ViewController.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/24/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MP3Converter.h"

@interface ViewController : UIViewController <AVAudioRecorderDelegate,MP3ConverterDelegate>

@end
