//
// Created by Larry Tin on 16/5/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GDLResolutionUtil : NSObject
+ (CGSize)videoSize:(NSString *)sessionPreset isPortrait:(BOOL)isPortrait;

+ (float)videoWidth:(NSString *)sessionPreset;

+ (float)videoHeight:(NSString *)sessionPreset;
@end