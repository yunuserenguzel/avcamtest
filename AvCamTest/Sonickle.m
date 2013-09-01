//
//  Sonickle.m
//  AvCamTest
//
//  Created by Yunus Eren Guzel on 8/31/13.
//  Copyright (c) 2013 Yunus Eren Guzel. All rights reserved.
//

#import "Sonickle.h"

@implementation Sonickle

+ (Sonickle*) sonickleFromDictionary:(NSDictionary*)dictionary
{
    UIImage* image = [UIImage imageWithData:[dictionary objectForKey:@"image"]];
    return [Sonickle sonickleWithImage:image andSound:[dictionary objectForKey:@"sound"] withId:[dictionary objectForKey:@"sonickleId"]];
}

- (NSDictionary*)dictionaryFromSonickle
{
    NSData* imageData = UIImageJPEGRepresentation(self.image, 1.0);
    return @{ @"image": imageData, @"sound": self.sound, @"sonickleId": self.sonickleId };
}

+ (Sonickle *)sonickleWithImage:(UIImage *)image andSound:(NSData *)sound withId:(NSString *)sonickleId
{
    return [[Sonickle alloc] initWithImage:image andSound:sound withId:sonickleId];
}


+ (Sonickle *)readFromFile:(NSString *)fileName
{
    return nil;
}

- (id)initWithImage:(UIImage *)image andSound:(NSData *)sound withId:(NSString *)sonickleId
{
    if(self = [super init]){
        _image = image;
        _sound = sound;
        _sonickleId = sonickleId;
    }
    return self;
}


- (void)saveToFile
{
    NSString* fileName = NSHomeDirectory();
    fileName = [fileName stringByAppendingPathComponent:@"Documents"];
    fileName = [fileName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.snc",self.sonickleId]];

    
    NSMutableArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:SonicklesUserDefaultsKey];
    if(array == nil){
        array = [[NSMutableArray alloc] init];
    }
    [array addObject:fileName];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:SonicklesUserDefaultsKey];
    
    NSDictionary* file = [self dictionaryFromSonickle];
    [file writeToFile:fileName atomically:YES];
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
//    long long fileSize = [fileSizeNumber longLongValue];
    
    NSLog(@"fileName: %@\nfileSize: %@",fileName,fileSizeNumber);
}


@end
