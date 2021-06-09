#
# Be sure to run `pod lib lint LKProvide.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LKProvide'
  s.version          = '1.0.3'
  s.summary          = 'LKProvide.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yfzxluculent/LKProvide'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yfzxluculent' => 'yfzx@luculant.net' }
  s.source           = { :git => 'https://github.com/yfzxluculent/LKProvide.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

# s.source_files = 'LKProvide/Classes/**/*{h,m}'
  

s.subspec 'Categories' do |ss|
ss.source_files  = 'LKProvide/Classes/Categories/**/*.{h,m}'

end

s.subspec 'Tools' do |ss|
    ss.subspec 'AuthorizationCenter' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/AuthorizationCenter/*.{h,m}'
    end

    ss.subspec 'HTBadgeHelper' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/HTBadgeHelper/*.{h,m}'
    end

    ss.subspec 'LKAlertController' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKAlertController/**/*.{h,m}'
    end
    ss.subspec 'LKCaptivePortal' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKCaptivePortal/*.{h,m}'
    end
    ss.subspec 'LKCodeScan' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKCodeScan/**/*.{h,m}'
    sss.resources    = "LKProvide/Classes/Tools/LKCodeScan/*.{png,bundle}"
    end
    ss.subspec 'LKDate' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKDate/*.{h,m}'
    end
    ss.subspec 'LKLanguage' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKLanguage/*.{h,m}'
    end
    ss.subspec 'LKNibBridge' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKNibBridge/*.{h,m}'
    end
    ss.subspec 'LKSafeTool' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKSafeTool/**/*.{h,m}'
    sss.resources    = "LKProvide/Classes/Tools/LKSafeTool/**/*.{png,bundle}"

    end
    ss.subspec 'LKScaleLevel' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKScaleLevel/*.{h,m}'
    end
    ss.subspec 'LKSkinTheme' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/LKSkinTheme/*.{h,m}'
    sss.resources    = "LKProvide/Classes/Tools/LKSkinTheme/**/*.{png,bundle}"

    end


    ss.subspec 'MWPhotoBrowser' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/MWPhotoBrowser/**/*.{h,m}'
    sss.resources    = "LKProvide/Classes/Tools/MWPhotoBrowser/*.{bundle}"
    sss.dependency 'DACircularProgress'
    sss.dependency 'SDWebImage', '5.0.1'
    sss.dependency 'MBProgressHUD', '1.1.0'

    end

    ss.subspec 'Signature' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/Signature/*.{h,m}'
    sss.dependency 'Masonry'
    end


    ss.subspec 'URLHelper' do |sss|
    sss.source_files  = 'LKProvide/Classes/Tools/URLHelper/*.{h,m}'
    end

end



  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'



end
