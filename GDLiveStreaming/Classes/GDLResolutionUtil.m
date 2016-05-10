//
// Created by Larry Tin on 16/5/9.
//

#import "GDLResolutionUtil.h"


@implementation GDLResolutionUtil {

}

+ (CGSize)videoSize:(NSString *)sessionPreset isPortrait:(BOOL)isPortrait {
  float width = [self videoWidth:sessionPreset];
  float height = [self videoHeight:sessionPreset];
  return isPortrait ? CGSizeMake(height, width) : CGSizeMake(width, height);
}

+ (float)videoWidth:(NSString *)sessionPreset {
  if ([AVCaptureSessionPreset1920x1080 isEqualToString:sessionPreset]) {
    return 1920;
  } else if ([AVCaptureSessionPreset1280x720 isEqualToString:sessionPreset]) {
    return 1280;
  } else if ([AVCaptureSessionPreset640x480 isEqualToString:sessionPreset]) {
    return 640;
  } else if ([AVCaptureSessionPreset352x288 isEqualToString:sessionPreset]) {
    return 352;
  } else {
    return 0;
  }
}

+ (float)videoHeight:(NSString *)sessionPreset {
  if ([AVCaptureSessionPreset1920x1080 isEqualToString:sessionPreset]) {
    return 1080;
  } else if ([AVCaptureSessionPreset1280x720 isEqualToString:sessionPreset]) {
    return 720;
  } else if ([AVCaptureSessionPreset640x480 isEqualToString:sessionPreset]) {
    return 480;
  } else if ([AVCaptureSessionPreset352x288 isEqualToString:sessionPreset]) {
    return 288;
  } else {
    return 0;
  }
}
@end