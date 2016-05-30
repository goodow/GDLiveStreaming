//
// Created by Larry Tin on 16/5/9.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

@protocol GDLStreamUploader <NSObject>
- (void)startUploadStreamWithURL:(NSString *)rtmpUrl andStreamKey:(NSString *)streamKey;

- (void)stopUploadStream;

@optional
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;

@end