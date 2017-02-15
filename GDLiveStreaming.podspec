#
# Be sure to run `pod lib lint GDLiveStreaming.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GDLiveStreaming"
  s.version          = "0.1.0"
  s.summary          = "Audio/Video Capturing->Filtering->Encoding->RTMP pushing"

  s.description      = <<-DESC
                       Live audio and video manipulation pipeline
                       DESC

  s.homepage         = "https://github.com/goodow/GDLiveStreaming"
  s.license          = 'MIT'
  s.author           = { "Larry Tin" => "dev@goodow.com" }
  s.source           = { :git => "https://github.com/goodow/GDLiveStreaming.git", :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '8.0'

  s.source_files = 'GDLiveStreaming/Classes/**/*', 'lib/libyuv/include/**/*.{h}'
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "${PODS_ROOT}/boost" }

  # s.resource_bundles = {
  #   'GDLiveStreaming' => ['GDLiveStreaming/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'GPUImage', '~> 0.1'
  s.dependency 'VideoCore', '~> 0.3'

  s.ios.vendored_libraries = 'lib/libyuv/libyuv.a'
  #s.header_dir = 'lib/libyuv/include'
  #s.header_mappings_dir = 'lib/libyuv/include'

end
