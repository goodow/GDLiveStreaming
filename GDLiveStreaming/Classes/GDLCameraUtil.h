//
//  Created by Larry Tin on 16/5/12.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImageView.h"
#import "GPUImageVideoCamera.h"

@interface GDLCameraUtil : NSObject

// Focusing and Exposure on tap
+ (void)captureDevice:(AVCaptureDevice *)device focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange;

// Convert tap's coordinates in preview view to the coordinate space of the capture device
+ (CGPoint)captureDevicePointOfInterestForPoint:(CGPoint)point inPreview:(GPUImageView *)previewView withVideoCamera:(GPUImageVideoCamera *)videoCamera;
@end
