#
# Be sure to run `pod lib lint MYIOSAdsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EdimobIOSAdsSDK'
  s.version          = '5.9.09'
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

  s.ios.deployment_target = '12.0'

  s.static_framework = true
  
  s.subspec 'Core' do |core|
     core.vendored_frameworks = 'MYIOSAdsSDK/Frameworks/*.framework'
     core.resources = 'MYIOSAdsSDK/Resources/**/*.bundle'
  end
  s.subspec 'CocoaHTTPServer' do |ss|
     ss.dependency 'KTVHTTPCache', '~> 3.1.0'
  end
  s.subspec 'ToponAdapter' do |ss|
     ss.source_files = 'MYIOSAdsSDK/ToponAdapter/**/*.{h,m}'
     ss.dependency 'AnyThinkiOS'
     ss.dependency 'EdimobIOSAdsSDK/Custom'
  end
  s.subspec 'AdScopeAdapter' do |ss|
     ss.source_files = 'MYIOSAdsSDK/AdScopeAdapter/**/*.{h,m}'
     ss.dependency 'AMPSAdSDK'
     ss.dependency 'EdimobIOSAdsSDK/Custom'
  end
  s.subspec 'Custom' do |ss|
     ss.vendored_frameworks = 'MYIOSAdsSDK/Frameworks-Cus/*.framework'
     ss.resources = 'MYIOSAdsSDK/Resources/**/*.bundle'
  end
  s.subspec 'SDWebImage' do |ss|
      ss.dependency 'SDWebImage','~> 5.21.1'
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
end
