//
//  Created by Larry Tin on 16/5/12.
//

#import "GDLCameraUtil.h"
#import "GDLResolutionUtil.h"

@implementation GDLCameraUtil

+ (void)captureDevice:(AVCaptureDevice *)device focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange {
  focusMode = focusMode == -1 ? device.focusMode : focusMode;
  exposureMode = exposureMode == -1 ? device.exposureMode : exposureMode;
  NSError *error = nil;
  if ([device lockForConfiguration:&error]) {
    // Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
    // Call -set(Focus/Exposure)Mode: to apply the new point of interest.
    if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode]) {
      device.focusPointOfInterest = point;
      device.focusMode = focusMode;
    }

    if (device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode]) {
      device.exposurePointOfInterest = point;
      device.exposureMode = exposureMode;
    }

    device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
    [device unlockForConfiguration];
  } else {
    NSLog(@"Could not lock device for configuration: %@", error);
  }
}

+ (CGPoint)captureDevicePointOfInterestForPoint:(CGPoint)point inPreview:(GPUImageView *)previewView withVideoCamera:(GPUImageVideoCamera *)videoCamera {
  CGSize size = previewView.frame.size;
  if (videoCamera.cameraPosition == AVCaptureDevicePositionFront) {
    point.x = size.width - point.x;
  }

  NSString *sessionPreset = videoCamera.captureSessionPreset;
  float videoWidthPixels = [GDLResolutionUtil videoWidth:sessionPreset];
  float videoHeightPixels = [GDLResolutionUtil videoHeight:sessionPreset];
  if (videoWidthPixels == 0 || videoHeightPixels == 0) {
    return CGPointMake(0.5, 0.5);
  }

  // 转换为基于Home键在右侧, 以左上角为原点的坐标
  float xInView;
  float yInView;
  float viewHeight;
  float viewWidth;
  switch (videoCamera.outputImageOrientation) {
    case UIInterfaceOrientationPortrait:
      viewHeight = size.width;
      viewWidth = size.height;
      xInView = point.y;
      yInView = viewHeight - point.x;
      break;
    case UIInterfaceOrientationLandscapeRight:
      viewHeight = size.height;
      viewWidth = size.width;
      xInView = point.x;
      yInView = point.y;
      break;
    case UIInterfaceOrientationLandscapeLeft:
      viewHeight = size.height;
      viewWidth = size.width;
      xInView = viewWidth - point.x;
      yInView = viewHeight - point.y;
      break;
  }
  CGFloat videoRatio = videoWidthPixels / videoHeightPixels;
  CGFloat viewRatio = viewWidth / viewHeight;
  float videoHeight;
  float videoWidth;
  float xInVideo;
  float yInVideo;
  switch (previewView.fillMode) {
    case kGPUImageFillModePreserveAspectRatioAndFill:
      if (videoRatio >= viewRatio) {
        videoHeight = viewHeight;
        videoWidth = videoHeight * videoRatio;
        yInVideo = yInView;
        xInVideo = xInView + (videoWidth - viewWidth) / 2;
      } else {
        videoWidth = viewWidth;
        videoHeight = videoWidth / videoRatio;
        xInVideo = xInView;
        yInVideo = yInView + (videoHeight - viewHeight) / 2;
      }
      break;
    case kGPUImageFillModePreserveAspectRatio:
      if (videoRatio >= viewRatio) {
        videoWidth = viewWidth;
        videoHeight = videoWidth / videoRatio;
        xInVideo = xInView;
        float blackBar = (viewHeight - videoHeight) / 2;
        if (yInView >= blackBar && yInView <= viewHeight - blackBar) {
          yInVideo = yInView - blackBar;
        }
      } else {
        videoHeight = viewHeight;
        videoWidth = videoHeight * videoRatio;
        yInVideo = yInView;
        float blackBar = (viewWidth - videoWidth) / 2;
        if (xInView >= blackBar && xInView <= viewWidth - blackBar) {
          xInVideo = xInView - blackBar;
        }
      }
      break;
    case kGPUImageFillModeStretch:
      videoWidth = viewWidth;
      videoHeight = viewHeight;
      xInVideo = xInView;
      yInVideo = yInView;
      break;
  }

  return CGPointMake(xInVideo / videoWidth, yInVideo / videoHeight);
}

@end
