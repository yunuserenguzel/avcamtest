//
//  SonickleMediaManager.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 9/8/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MP3Converter.h"
#import "UIImage+scaleToSize.h"

typedef void (^ ImageBlock)(UIImage* image);

@class SonickleMediaManager;

@protocol SonickleMediaProtocol <NSObject>

- (void)manager:(SonickleMediaManager*)manager audioDataReady:(NSData*)data;

@end

@interface SonickleMediaManager : NSObject <AVAudioRecorderDelegate,MP3ConverterDelegate>

@property (nonatomic) UIView* cameraView;

@property id<SonickleMediaProtocol> delegate;

- (id) initWithView:(UIView*)view;

- (void) takePictureWithCompletionBlock:(ImageBlock)completionBlock;

- (void) startAuidoRecording;

- (void) stopAudioRecording;

- (void) startCamera;

- (void) stopCamera;

@end
