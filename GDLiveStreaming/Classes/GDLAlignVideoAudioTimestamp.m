//
//  Created by Larry Tin on 16/3/30.
//

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "GDLAlignVideoAudioTimestamp.h"

static const float maxFrameTimeOffset = 4.f * 1 / 43;

@implementation GDLAlignVideoAudioTimestamp {
  __weak GPUImageVideoCamera *_videoCamera;
  AVCaptureSession *_captureSession;

  CMTime _timeOffset;
  CMTime _lastAudioTime;
  BOOL _discont;
  BOOL _isPaused;
  CMTime _lastVideoTime;

  CTCallCenter *_callCenter;
}

- (instancetype)initWithVideoCamera:(GPUImageVideoCamera *)camera {
  self = [super init];
  if (self) {
    _videoCamera = camera;
    _captureSession = _videoCamera.captureSession;

    _timeOffset = CMTimeMake(0, 0);
    _callCenter = [[CTCallCenter alloc] init];
    __weak GDLAlignVideoAudioTimestamp *weakSelf = self;
    _callCenter.callEventHandler = ^(CTCall *call) {
        if ([call.callState isEqualToString:CTCallStateIncoming]) {
          NSLog(@"CTCallCenter: call Incoming");
          [camera pauseCameraCapture];
          [weakSelf pauseRecording];
        } else if ([call.callState isEqualToString:CTCallStateDisconnected]) {
          NSLog(@"CTCallCenter: call Disconnected");
          [camera resumeCameraCapture];
          [weakSelf resumeRecording];
        }
    };
  }

  return self;
}

- (void)dealloc {
  _callCenter.callEventHandler = nil;
  _callCenter = nil;
}

- (CMTime)calculateVideoTimestamp:(CMTime)frameTime {
//  NSLog(@"videoFrame: %f", ((double) frameTime.value) / frameTime.timescale);
  if (_discont) {
    return kCMTimeInvalid;
  }
  CMTime offset = CMTimeSubtract(frameTime, _lastAudioTime);
  double offsetDuration = ((double) offset.value) / offset.timescale;
  if (offsetDuration > maxFrameTimeOffset) {
    CMTime videoOffset = CMTimeSubtract(frameTime, _lastVideoTime);
    NSLog(@"%s: drop video frame, audioOffset = %f, videoOffset = %f", __PRETTY_FUNCTION__, offsetDuration, ((double) videoOffset.value) / videoOffset.timescale);
//    frameTime = CMTimeAdd(_lastVideoTime, CMTimeMakeWithSeconds((double) 1.0 / QQLSettingsEntry.instance.broadcast.frameRate / 5, NSEC_PER_SEC));
    return kCMTimeInvalid;
  } else if (_timeOffset.value > 0) {
    frameTime = CMTimeSubtract(frameTime, _timeOffset);
  }
  if (_lastVideoTime.value != 0 && CMTIME_COMPARE_INLINE(frameTime, <=, _lastVideoTime)) {
    NSLog(@"%s: drop video frame, frameTime(%f) <= lastVideoTime(%f)", __PRETTY_FUNCTION__, ((double) frameTime.value) / frameTime.timescale, ((double) _lastVideoTime.value) / _lastVideoTime.timescale);
    return kCMTimeInvalid;
  }

  _lastVideoTime = frameTime;
  return frameTime;
}

- (BOOL)checkAudioTimestamp:(CMSampleBufferRef)audioBuffer {
  CMTime pts = CMSampleBufferGetPresentationTimeStamp(audioBuffer);
//  NSLog(@"audioFrame: %f", ((double) pts.value) / pts.timescale);

  static CMTime last;
  BOOL invalid = last.value != 0 && CMTIME_COMPARE_INLINE(pts, <=, last);
  if (invalid) {
    NSLog(@"%s: frameTime(%f) <= lastAudioTime(%f)", __PRETTY_FUNCTION__, ((double) pts.value) / pts.timescale, ((double) last.value) / last.timescale);
  } else {
    last = pts;
  }
  if (_isPaused || invalid) {
    return NO;
  }

  CMTime offset = CMTimeSubtract(pts, _lastAudioTime);
  double offsetDuration = ((double) offset.value) / offset.timescale;
  if (!_discont && (offsetDuration > maxFrameTimeOffset)) {
    _discont = YES;
  }
  if (_discont) {
    _discont = NO;
    // calc adjustment
    if (_lastAudioTime.flags & kCMTimeFlags_Valid) {
      NSLog(@"%s: Adding %f to %f (pts %f)", __PRETTY_FUNCTION__, offsetDuration, ((double) _timeOffset.value) / _timeOffset.timescale, ((double) pts.value / pts.timescale));

      // this stops us having to set a scale for _timeOffset before we see the first video time
      if (_timeOffset.value == 0) {
        _timeOffset = offset;
      } else {
        _timeOffset = CMTimeAdd(_timeOffset, offset);
      }
    }
    _lastAudioTime.flags = 0;
  }

  // record most recent time so we know the length of the pause
  _lastAudioTime = pts;
  CMTime dur = CMSampleBufferGetDuration(audioBuffer);
  if (dur.value > 0) {
    _lastAudioTime = CMTimeAdd(_lastAudioTime, dur);
  }
//  if (_timeOffset.value > 0) {
//    audioBuffer = [self.class adjustTime:audioBuffer by:_timeOffset];
//  }

  return YES;
}

- (void)pauseRecording {
  if (!_isPaused) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
  }
  _isPaused = YES;
  _discont = YES;
}

- (void)resumeRecording {
  if (!_captureSession.isInterrupted) {
    NSLog(@"%s", __PRETTY_FUNCTION__);
  }
  _isPaused = NO;
}

+ (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset {
  CMItemCount count;
  CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
  CMSampleTimingInfo *pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
  CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
  for (CMItemCount i = 0; i < count; i++) {
    pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
    pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
  }
  CMSampleBufferRef sout;
  CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
  free(pInfo);
  return sout;
}
@end
