#
# Be sure to run `pod lib lint MYIOSAdsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EdimobIOSAdsSDK'
  s.version          = '1.0.2'
  s.summary          = 'A short description of EdimobIOSAdsSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/shanghaimeiyue/EdimobIOSAdsSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shanghaimeiyue' => 'karl@edimob.com' }
  s.source           = { :git => 'https://github.com/shanghaimeiyue/EdimobIOSAdsSDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.static_framework = true
  s.resources = 'MYIOSAdsSDK/Resources/*.bundle'
  s.vendored_frameworks = 'MYIOSAdsSDK/Frameworks/*.framework'
  
  s.subspec 'CocoaHTTPServer' do |cohttpserver|
      cohttpserver.dependency 'CocoaHTTPServer'
      cohttpserver.dependency 'CocoaLumberjack', '~>1.3.0'
  end
  s.subspec 'SDWebImage' do |sdWebImage|
      sdWebImage.dependency 'SDWebImage'
  end
  s.subspec 'Masonry' do |masonry|
      masonry.dependency 'Masonry'
  end
  s.subspec 'KSCrash' do |kSCrash|
      kSCrash.dependency 'KSCrash', '~> 1.17.7'
  end
#  s.dependency 'CocoaHTTPServer'
#  s.dependency 'CocoaLumberjack', '~>1.3.0'
  #s.dependency 'WechatOpenSDK_UnPay'
#  s.dependency 'SDWebImage'
#  s.dependency 'Masonry'
#  s.dependency 'KSCrash', '~> 1.17.7'
end
