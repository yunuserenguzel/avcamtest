//
//  Sonickle.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SonicklesUserDefaultsKey @"SonicklesUserDefaultsKey"
#import "UIImage+scaleToSize.h"

@interface Sonickle : NSObject


+ (Sonickle*) sonickleFromDictionary:(NSDictionary*)dictionary;

+ (Sonickle*) readFromFile:(NSString*)fileName;


+ (Sonickle*) sonickleWithImage:(UIImage*)image andSound:(NSData*)sound withId:(NSString*)sonickleId;

- (NSDictionary*)dictionaryFromSonickle;


- (id) initWithImage:(UIImage*)image andSound:(NSData*)sound withId:(NSString*)sonickleId;

@property (nonatomic) NSString* sonickleId;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSData* sound;
@property (nonatomic) UIImage* thumbnail;


- (void) saveToFile;

@end
