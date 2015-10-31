Pod::Spec.new do |s|
  s.name             = "PageCollectionViewLayout"
  s.version          = "0.0.1"
  s.summary          = "A quick and dirty UICollectionFlowLayout that mimics some of the UIPageViewController."
  s.description      = <<-DESC
I did not like how the UIPageViewController handled data. I didn't really need a new viewcontroller for each screen so I developed a UICollectionViewLay (subclass of UICollectionFlowLayout) that would mimic the look but would allow me to preform data updates similar to that of the UITableViewContoller.
                       DESC

  s.homepage         = "https://github.com/someoneAnyone/PageCollectionViewLayout"
  s.license          = 'MIT'
  s.author           = { "Pete" => "peter.ina@gmail.com" }
  s.source           = { :git => "https://github.com/someoneAnyone/PageCollectionViewLayout.git", :tag => s.version }
  s.social_media_url = 'https://twitter.com/peter_ina'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PageCollectionViewLayout' => ['Pod/Assets/*.png']
  }

end
