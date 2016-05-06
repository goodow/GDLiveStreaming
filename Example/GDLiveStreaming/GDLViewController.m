//
//  GDLViewController.m
//  GDLiveStreaming
//
//  Created by Larry Tin on 05/06/2016.
//  Copyright (c) 2016 Larry Tin. All rights reserved.
//

#import <GPUImage/GPUImageView.h>
#import <GPUImage/GPUImageFilter.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImageVideoCamera.h>
#import <GPUImage/GPUImageRawDataOutput.h>
#import "GDLViewController.h"
#import "GDLRawDataOutput.h"
#import "GPUImageMovieWriter.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface GDLViewController ()

@end

@implementation GDLViewController {
  GDLRawDataOutput *_output;
  GPUImageVideoCamera *_videoCamera;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
  _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
  _videoCamera.frameRate = 20;

  CGSize viewSize = self.view.frame.size;
  GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewSize.width, viewSize.height)];
  [self.view addSubview:filteredVideoView];

  [_videoCamera addTarget:filteredVideoView];
  CGSize size = CGSizeMake(720, 1280);
  _output = [[GDLRawDataOutput alloc] initWithVideoCamera:_videoCamera withImageSize:size];
  [_videoCamera addTarget:_output];

  NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
  unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
  NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
  GPUImageMovieWriter *movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:size];
  movieWriter.encodingLiveVideo = YES;
  [_videoCamera addTarget:movieWriter];

  [_videoCamera startCameraCapture];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
      _videoCamera.audioEncodingTarget = movieWriter;
      [movieWriter startRecording];
      [_output startUploadStreamWithURL:@"rtmp://a.rtmp.youtube.com/live2" andStreamKey:@"323c-p07x-2g2e-c57k"];

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 120.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
          [_videoCamera removeTarget:movieWriter];
          _videoCamera.audioEncodingTarget = nil;
          [movieWriter finishRecording];
          NSLog(@"Movie completed");

          ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
          if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:movieURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                     delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                    } else {
                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                     delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      [alert show];
                    }
                });
            }];
          }
      });
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
