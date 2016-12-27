#
# Be sure to run `pod lib lint MyOftenUseTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MyOftenUseTool'
  s.version          = '0.4.4'
  s.summary          = '自己常用的一些封装方法和UIKIT，Foundation框架的category添加的方法,里面已经添加了最新的AFN,pop,SAMKeychain等依赖的框架'

  s.description      = <<-DESC
这是我自己根据项目中常用的方法和在网络上收集的一些比较好用的iOS原有的框架上添加的category，方便自己在开发中的使用，里面已经添加了最新的AFN,pop,SAMKeychain等依赖的框架
DESC


  s.homepage         = 'https://github.com/zhangjiang1203/MyOftenUseTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhangjiang' => '896884553@qq.com' }
  s.source           = { :git => 'https://github.com/zhangjiang1203/MyOftenUseTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files  = 'MyOftenUseTool/Classes/ZJMethodHeader.h'
  s.public_header_files = 'MyOftenUseTool/Classes/ZJMethodHeader.h'

#添加新的文件时，先更新一下这个本地的类库
#  s.source_files  = 'MyOftenUseTool/**/*.{h,m}'
#  s.public_header_files = 'MyOftenUseTool/**/*.h'

  #s.exclude_files = "MyOftenUseTool/Exclude"

  # s.resource_bundles = {
  #   'MyOftenUseTool' => ['MyOftenUseTool/Assets/*.png']
  # }

  s.frameworks = 'UIKit', 'MapKit','QuartzCore','Foundation'
  s.dependency 'AFNetworking', '~> 3.1.0'
#动画引擎
  s.dependency 'pop'
#密码保存
  s.dependency 'SAMKeychain'
  s.dependency 'SVProgressHUD'
  s.dependency 'YYCache'
  s.requires_arc = true

  #创建个人目录
  s.subspec 'HUDMethod' do |hudMethod|
    hudMethod.source_files = 'MyOftenUseTool/Classes/HUDHelper.{h,m}'
   hudMethod.public_header_files = 'MyOftenUseTool/Classes/HUDHelper.h'
  end

  s.subspec 'SystemMethod' do |ss|
   ss.source_files = 'MyOftenUseTool/Classes/ZJSystemUtils.{h,m}'
    ss.public_header_files = 'MyOftenUseTool/Classes/ZJSystemUtils.h'
  end

  s.subspec 'WaveAnimation' do |ss|
    ss.source_files = 'MyOftenUseTool/Classes/WaveAnimation.{h,m}'
    ss.public_header_files = 'MyOftenUseTool/Classes/WaveAnimation.h'
    ss.resource_bundles = {
      'MyOftenUseTool' => ['MyOftenUseTool/Classes/Resource.bundle']
    }
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
