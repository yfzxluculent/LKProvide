#
# Be sure to run `pod lib lint LKProvide.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LKProvide'
  s.version          = '0.1.9'
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

  s.source_files = 'LKProvide/Classes/**/*{h,m}'
  
s.resources    = "LKProvide/Classes/**/*.{png,bundle}"
s.vendored_libraries = 'LKProvide/Classes/**/*.a'

s.subspec 'Categories' do |ss|
ss.source_files  = 'LKProvide/Classes/Categories/**/*.{h,m}'
end

#s.subspec 'AuthorizationCenter' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/AuthorizationCenter/*.{h,m}'
#end

#s.subspec 'HTBadgeHelper' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/HTBadgeHelper/*.{h,m}'
#end

#s.subspec 'LKAlertController' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKAlertController/**/*.{h,m}'
#end
#s.subspec 'LKCaptivePortal' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKCaptivePortal/*.{h,m}'
#end
#s.subspec 'LKCodeScan' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKCodeScan/**/*.{h,m}'
#end
#s.subspec 'LKDate' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKDate/*.{h,m}'
#end
#s.subspec 'LKLanguage' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKLanguage/*.{h,m}'
#end
#s.subspec 'LKNibBridge' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKNibBridge/*.{h,m}'
#end
#s.subspec 'LKSafeTool' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKSafeTool/**/*.{h,m}'
#end
#s.subspec 'LKScaleLevel' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKScaleLevel/*.{h,m}'
#end
#s.subspec 'LKSkinTheme' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/LKSkinTheme/*.{h,m}'
#end


#s.subspec 'MWPhotoBrowser' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/MWPhotoBrowser/**/*.{h,m}'
#end

#s.subspec 'Signature' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/Signature/*.{h,m}'
#end


#s.subspec 'URLHelper' do |ss|
#ss.source_files  = 'LKProvide/Classes/Tools/URLHelper/*.{h,m}'
#end



  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

s.dependency 'DACircularProgress'
s.dependency 'SDWebImage', '5.0.1'
s.dependency 'MBProgressHUD', '1.1.0'
s.dependency 'Masonry'

end
