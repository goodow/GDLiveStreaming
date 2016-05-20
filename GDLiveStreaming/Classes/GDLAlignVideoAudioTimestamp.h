//
//  Created by Larry Tin on 16/3/30.
//

#import "GPUImageVideoCamera.h"

@interface GDLAlignVideoAudioTimestamp : NSObject

- (instancetype)initWithVideoCamera:(GPUImageVideoCamera *)camera;

- (CMTime)calculateVideoTimestamp:(CMTime)frameTime;

- (BOOL)checkAudioTimestamp:(CMSampleBufferRef)audioBuffer;

- (void)pauseRecording;

- (void)resumeRecording;

@end