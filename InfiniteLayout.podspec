#
# Be sure to run `pod lib lint InfiniteLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InfiniteLayout'
  s.version          = '0.4'
  s.summary          = 'Horizontal and Vertical infinite scrolling feature for UICollectionView with Paging, NSProxy delegate, Reactive extension'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Horizontal and Vertical infinite scrolling feature for UICollectionView with Paging, NSProxy delegate, Reactive extension, SectionModel & AnimatableSectionModel support
                       DESC

  s.homepage         = 'https://github.com/arnauddorgans/InfiniteLayout'
  s.screenshots     = 'https://github.com/arnauddorgans/InfiniteLayout/raw/master/horizontal.gif', 'https://github.com/arnauddorgans/InfiniteLayout/raw/master/vertical.gif', 'https://github.com/arnauddorgans/InfiniteLayout/raw/master/custom.gif', 'https://github.com/arnauddorgans/InfiniteLayout/raw/master/delegate.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Arnaud Dorgans' => 'ineox@me.com' }
  s.source           = { :git => 'https://github.com/arnauddorgans/InfiniteLayout.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/arnauddorgans'

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  
#s.xcconfig = { 'SWIFT_OBJC_BRIDGING_HEADER' => '${POD_ROOT}/InfiniteLayout/BridgeHeader.h' }
  
  # s.resource_bundles = {
  #   'InfiniteLayout' => ['InfiniteLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CocoaProxy', '~> 0'

  s.default_subspec = 'Core'

    s.subspec 'Core' do |core|
        core.source_files = 'InfiniteLayout/Classes/**/*'
    end

    s.subspec 'Rx' do |rx|
        rx.dependency 'InfiniteLayout/Core', '~> 0'
        rx.dependency 'RxSwift', '~> 4.5'
        rx.dependency 'RxCocoa', '~> 4.5'
        rx.dependency 'RxDataSources', '~> 3.1'
        rx.source_files = 'InfiniteLayout/Rx/**/*'
    end
end
