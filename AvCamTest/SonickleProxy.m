//
//  SonickleProxy.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 9/1/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "SonickleProxy.h"

@interface SonickleProxy ()

@property NSString* fileName;


@end

@implementation SonickleProxy
{
    
}
- (id)initWithSonickleFileName:(NSString *)fileName
{
    if(self = [super init]){
        self.fileName = fileName;
        NSDictionary* dictionary = [NSDictionary dictionaryWithContentsOfFile:fileName];
        self.sonickleId = [dictionary objectForKey:@"sonickleId"];
        
        NSData* imageData = [[NSDictionary dictionaryWithContentsOfFile:self.fileName] objectForKey:@"image"];
        UIImage* image = [UIImage imageWithData:imageData];
        self.thumbnail = [image imageByScalingAndCroppingForSize:CGSizeMake(144.0, 144.0)];
    }
    
    return self;
}

- (UIImage *)image
{
    UIImage* image = [UIImage imageWithData:[[NSDictionary dictionaryWithContentsOfFile:self.fileName] objectForKey:@"image"]];
    return image;
}


- (NSData *)sound
{
    return [[NSDictionary dictionaryWithContentsOfFile:self.fileName] objectForKey:@"sound"];
}
@end
