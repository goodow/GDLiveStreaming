# GDLiveStreaming

[![CI Status](http://img.shields.io/travis/Larry Tin/GDLiveStreaming.svg?style=flat)](https://travis-ci.org/Larry Tin/GDLiveStreaming)
[![Version](https://img.shields.io/cocoapods/v/GDLiveStreaming.svg?style=flat)](http://cocoapods.org/pods/GDLiveStreaming)
[![License](https://img.shields.io/cocoapods/l/GDLiveStreaming.svg?style=flat)](http://cocoapods.org/pods/GDLiveStreaming)
[![Platform](https://img.shields.io/cocoapods/p/GDLiveStreaming.svg?style=flat)](http://cocoapods.org/pods/GDLiveStreaming)

## Features

* Capturing and filtering live video via [GPUImage](https://github.com/BradLarson/GPUImage)
* Focusing and Exposure on tap: [GDLCameraUtil](https://github.com/goodow/GDLiveStreaming/blob/master/GDLiveStreaming/Classes/GDLCameraUtil.h)
* Pause and resume during recording: [GDLAlignVideoAudioTimestamp](https://github.com/goodow/GDLiveStreaming/blob/master/GDLiveStreaming/Classes/GDLAlignVideoAudioTimestamp.h)
  * Rotate camera between front and rear
  * Incoming call
  * Alarm
* H264 video encoding using VideoToolbox
* Push stream through [RTMP](https://en.wikipedia.org/wiki/Real_Time_Messaging_Protocol)

## Example

To run the example project:
  1. Clone the repo, run `git submodule update --init` in the root directory.
  2. Run `pod install` from the Example directory and open `GDLiveStreaming.xcworkspace` file.

## Requirements

## Installation

GDLiveStreaming is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GDLiveStreaming', :git => 'https://github.com/goodow/GDLiveStreaming.git'
pod 'VideoCore', :git => 'https://github.com/goodow/VideoCore.git'
pod 'glm', :podspec => 'https://raw.githubusercontent.com/goodow/GDLiveStreaming/master/glm.podspec'
```

## Author

Larry Tin, dev@goodow.com

## License

GDLiveStreaming is available under the MIT license. See the LICENSE file for more info.
