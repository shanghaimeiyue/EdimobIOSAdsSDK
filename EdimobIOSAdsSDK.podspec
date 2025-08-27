#
# Be sure to run `pod lib lint MYIOSAdsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EdimobIOSAdsSDK'
  s.version          = '5.8.21'
  s.summary          = 'A short description of EdimobIOSAdsSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
EdimobIOSAdsSDK 是一个用于 iOS 平台的广告 SDK，提供横幅广告、插屏广告、激励视频等多种广告形式的集成能力，支持与主流广告平台对接，简化开发者的广告集成流程，同时包含资源管理、网络请求等辅助功能。
                      DESC

  s.homepage         = 'https://github.com/shanghaimeiyue/EdimobIOSAdsSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shanghaimeiyue' => 'karl@edimob.com' }
  s.source           = { :git => 'https://github.com/shanghaimeiyue/EdimobIOSAdsSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.static_framework = true
  
#  s.vendored_frameworks = 'MYIOSAdsSDK/Frameworks/*.framework'
 
  s.subspec 'Core' do |core|
     core.vendored_frameworks = 'MYIOSAdsSDK/Frameworks/*.framework'
     core.resources = 'MYIOSAdsSDK/Resources/**/*.bundle'
  end
  s.subspec 'CocoaHTTPServer' do |ss|
      ss.vendored_frameworks = 'MYIOSAdsSDK/Frameworks/**/*.framework'
  end
  s.subspec 'SDWebImage' do |ss|
      ss.dependency 'SDWebImage'
  end
  s.subspec 'Masonry' do |ss|
      ss.dependency 'Masonry'
  end
  s.subspec 'KSCrash' do |ss|
      ss.dependency 'KSCrash', '~> 1.17.7'
  end
  s.subspec 'WechatOpenSDK' do |ss|
      ss.dependency 'WechatOpenSDK'
  end
  s.default_subspecs = 'Core'
#  s.dependency 'CocoaHTTPServer'
#  s.dependency 'CocoaLumberjack', '~>1.3.0'
  #s.dependency 'WechatOpenSDK_UnPay'
#  s.dependency 'SDWebImage'
#  s.dependency 'Masonry'
#  s.dependency 'KSCrash', '~> 1.17.7'
end
