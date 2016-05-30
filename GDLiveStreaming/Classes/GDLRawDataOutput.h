//
// Created by Larry Tin on 15/12/28.
//

#import <Foundation/Foundation.h>
#import "GDLStreamUploader.h"
#import "GPUImageRawDataOutput.h"
#import "GPUImageVideoCamera.h"

@protocol GPUImageAudioEncodingTarget
- (BOOL)hasAudioTrack;

- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;
@end

@interface GDLRawDataOutput : GPUImageRawDataOutput <GDLStreamUploader>

- (instancetype)initWithVideoCamera:(GPUImageVideoCamera *)camera withImageSize:(CGSize)newImageSize;

@end