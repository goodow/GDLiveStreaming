//
// Created by Larry Tin on 15/12/28.
// Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImageRawDataOutput.h>
#import <GPUImage/GPUImageVideoCamera.h>

@class GPUImageVideoCamera;
@protocol GPUImageAudioEncodingTarget
- (BOOL)hasAudioTrack;

- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;
@end

@interface GDLRawDataOutput : GPUImageRawDataOutput <GPUImageVideoCameraDelegate, GPUImageAudioEncodingTarget>

- (instancetype)initWithVideoCamera:(GPUImageVideoCamera *)camera withImageSize:(CGSize)newImageSize;

- (void)startUploadStreamWithURL:(NSString *)rtmpUrl andStreamKey:(NSString *)streamKey;

- (void)stopUploadStream;

@end