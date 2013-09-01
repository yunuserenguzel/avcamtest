//
//  Sonickle.h
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SonicklesUserDefaultsKey @"SonicklesUserDefaultsKey"


@interface Sonickle : NSObject


+ (Sonickle*) sonickleFromDictionary:(NSDictionary*)dictionary;

+ (Sonickle*) readFromFile:(NSString*)fileName;
+ (Sonickle*) sonickleWithImage:(UIImage*)image andSoundURL:(NSURL*)soundUrl withId:(NSString*)sonickleId;

+ (Sonickle*) sonickleWithImage:(UIImage*)image andSound:(NSData*)sound withId:(NSString*)sonickleId;

- (NSDictionary*)dictionaryFromSonickle;


- (id) initWithImage:(UIImage*)image andSound:(NSData*)sound withId:(NSString*)sonickleId;

@property (readonly) NSString* sonickleId;
@property (readonly) UIImage* image;
@property (readonly) NSData* sound;


- (void) saveToFile;

@end
