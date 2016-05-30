//
// Created by Larry Tin on 15/12/28.
//

#import "GDLRawDataOutput.h"
#import <videocore/api/iOS/VCSimpleSession.h>

using namespace videocore;

@interface GDLRawDataOutput () <VCSessionDelegate, GPUImageVideoCameraDelegate, GPUImageAudioEncodingTarget>
@end

@implementation GDLRawDataOutput {
  __weak GPUImageVideoCamera *_videoCamera;
  VCSimpleSession *_session;
  BOOL _upload;
}

- (instancetype)initWithVideoCamera:(GPUImageVideoCamera *)camera withImageSize:(CGSize)size {
  self = [super initWithImageSize:size resultsInBGRAFormat:YES];
  if (self) {
    _videoCamera = camera;
//    _videoCamera.audioEncodingTarget = (id) self;

    _session = [[VCSimpleSession alloc] initWithVideoSize:size frameRate:_videoCamera.frameRate bitrate:4000 * 1024];
    _session.useAdaptiveBitrate = YES;
    _session.delegate = self;
  }

  return self;
}

- (void)startUploadStreamWithURL:(NSString *)rtmpUrl
                    andStreamKey:(NSString *)streamKey {
  _upload = YES;
  [_session startRtmpSessionWithURL:rtmpUrl andStreamKey:streamKey];
}

- (void)stopUploadStream {
  if (!_upload) {
    return;
  }
  _upload = NO;
  [_session endRtmpSession];
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex {
  [super newFrameReadyAtTime:frameTime atIndex:textureIndex];

  if (!_upload) {
    return;
  }
  [self lockFramebufferForReading];
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  GLubyte *sourceBytes = self.rawBytesForImage;
  NSInteger bytesPerRow = self.bytesPerRowInOutput;

  CVPixelBufferRef pixelBuffer = NULL;
  OSStatus result = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, sourceBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
  CMVideoFormatDescriptionRef videoInfo = NULL;
  result = CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer, &videoInfo);
  CMSampleTimingInfo timingInfo = {0,};
  timingInfo.duration = kCMTimeInvalid;
  timingInfo.decodeTimeStamp = kCMTimeInvalid;
  timingInfo.presentationTimeStamp = frameTime;

  _session->m_cameraSource->bufferCaptured(pixelBuffer);
  CFRelease(videoInfo);
  CVPixelBufferRelease(pixelBuffer);
  [self unlockFramebufferAfterReading];
}

- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
}

- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer {
  if (!_upload) {
    return;
  }
}

- (BOOL)hasAudioTrack {
  return YES;
}

- (void)connectionStatusChanged:(VCSessionState)state {
  switch (state) {
    case VCSessionStateStarting:
      break;
    case VCSessionStateStarted:
      break;
    default:
      break;
  }
}
@end