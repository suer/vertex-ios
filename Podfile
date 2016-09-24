platform :ios, "9.0"
use_frameworks!
inhibit_all_warnings!

target 'Vertex' do
  pod 'SwiftyJSON', '~> 3.0.0'
  pod 'Ji', '~> 2.0.0'
  pod 'KeychainAccess', '~> 3.0.0'
  pod 'APIKit', '3.0.0-beta.2'
  pod 'SVProgressHUD'
  pod 'MCSwipeTableViewCell'
  pod 'PullToRefresher', '~> 2.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
