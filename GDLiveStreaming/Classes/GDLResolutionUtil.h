//
// Created by Larry Tin on 16/5/9.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

struct GDLRange {
  CGFloat min;
  CGFloat max;
};
typedef struct GDLRange GDLRange;
struct GDLResolution {
  CGSize size;
  struct GDLRange bitrate;
};
typedef struct GDLResolution GDLResolution;

extern const struct GDLResolution GDLResolution1440p60fps;
extern const struct GDLResolution GDLResolution1440p;
extern const struct GDLResolution GDLResolution1080p60fps;
extern const struct GDLResolution GDLResolution1080p;
extern const struct GDLResolution GDLResolution720p60fps;
extern const struct GDLResolution GDLResolution720p;
extern const struct GDLResolution GDLResolution480p;
extern const struct GDLResolution GDLResolution360p;
extern const struct GDLResolution GDLResolution240p;

@interface GDLResolutionUtil : NSObject
+ (CGSize)videoSize:(NSString *)sessionPreset isPortrait:(BOOL)isPortrait;

+ (float)videoWidth:(NSString *)sessionPreset;

+ (float)videoHeight:(NSString *)sessionPreset;
@end