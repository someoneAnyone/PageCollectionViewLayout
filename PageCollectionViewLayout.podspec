#
# Be sure to run `pod lib lint PageCollectionViewLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PageCollectionViewLayout"
  s.version          = "0.1.0"
  s.summary          = "A quick and dirty UICollectionFlowLayout that mimics some of the UIPageViewController."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
I did not like how the UIPageViewController handled data. I didn't really need a new viewcontroller for each screen so I developed a UICollectionViewLay (subclass of UICollectionFlowLayout) that would mimic the look but would allow me to preform data updates similar to that of the UITableViewContoller.
                       DESC

  s.homepage         = "https://github.com/someoneAnyone/PageCollectionViewLayout"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Pete" => "peter.ina@gmail.com" }
  s.source           = { :git => "https://github.com/someoneAnyone/PageCollectionViewLayout.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/peter_ina'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PageCollectionViewLayout' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
