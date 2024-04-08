#
# Be sure to run `pod lib lint USReader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'USReader'
  s.version          = '0.1.9'
  s.summary          = 'A short description of USReader.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A novel reader for cloudreve.
                       DESC

  s.homepage         = 'https://github.com/nongyun.cao/USReader'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'noah37' => '2252055382@qq.com' }
  s.source           = { :git => 'git@github.com:Noah37/USReader.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'USReader/Classes/**/*'
  
   s.resource_bundles = {
     'USReader' => ['USReader/Assets/*']
   }

   s.public_header_files = 'USReader/Classes/**/*.h', 'USReader/Classes/Speech/iflyMSC.framework/Headers/*.h'
   s.frameworks = 'UIKit', 'MapKit', 'CoreTelephony', 'CFNetwork', 'SystemConfiguration', 'Security', 'CoreFoundation', 'MobileCoreServices'
   s.libraries = 'c++', 'iconv', 'xml2', 'z'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.vendored_frameworks = 'USReader/Classes/Speech/iflyMSC.framework'
  s.dependency 'Masonry'
  s.dependency 'YYCategories'
  s.dependency 'YYModel'
  s.dependency 'SDWebImage'
  s.dependency 'SpeechEngineTtsToB', '5.4.2.1-bugfix'
end
