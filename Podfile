platform :ios, "12.0"
use_frameworks!
inhibit_all_warnings!

target 'Vertex' do
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'Kanna', '~> 5.0.0'
  pod 'KeychainAccess', '~> 3.2.0'
  pod 'APIKit', '5.0.0'
  pod 'SVProgressHUD'
  pod 'MCSwipeTableViewCell'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
