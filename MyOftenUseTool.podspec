#
# Be sure to run `pod lib lint MyOftenUseTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MyOftenUseTool'
  s.version          = '0.1.9'
  s.summary          = '自己常用的一些封装方法和UIKIT，Foundation框架的category添加的方法'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
这是我自己根据项目中常用的方法和在网络上收集的一些比较好用的iOS原有的框架上添加的category，方便自己在开发中的使用
DESC


  s.homepage         = 'https://github.com/zhangjiang1203/MyOftenUseTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangjiang' => '896884553@q.com' }
  s.source           = { :git => 'https://github.com/zhangjiang1203/MyOftenUseTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

 # s.source_files  = 'MyOftenUseTool/Classes/ZJMethodHeader.h'
 # s.public_header_files = 'MyOftenUseTool/Classes/ZJMethodHeader.h'

  s.source_files  = 'MyOftenUseTool/**/*.{h,m}'
  s.public_header_files = 'MyOftenUseTool/**/*.h'

  #s.exclude_files = "MyOftenUseTool/Exclude"

  # s.resource_bundles = {
  #   'MyOftenUseTool' => ['MyOftenUseTool/Assets/*.png']
  # }

  s.frameworks = 'UIKit', 'MapKit','QuartzCore','Foundation'
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'pop'
  s.requires_arc = true

  #创建个人目录
  s.subspec 'HUDMethod' do |hudMethod|
    hudMethod.source_files = 'MyOftenUseTool/Classes/HUDHelper.{h,m}'
    hudMethod.public_header_files = 'MyOftenUseTool/Classes/HUDHelper.h'
  end

  s.subspec 'AFNRequest' do |afnRequest|
   afnRequest.source_files = 'MyOftenUseTool/Classes/ZJAFNRequestTool.{h,m}'
   afnRequest.public_header_files = 'MyOftenUseTool/Classes/ZJAFNRequestTool.h'

  end

  s.subspec 'UIKit+Category' do |ss|
    ss.source_files = 'MyOftenUseTool/UIKit/*.{h,m}'
    ss.public_header_files = 'MyOftenUseTool/UIKit/*.h'
    
  end

  s.subspec 'Foundation+Category' do |ss|
    ss.source_files = 'MyOftenUseTool/Foundation/**'
    ss.public_header_files = 'MyOftenUseTool/Foundation/*.h'
    
  end
  

end
