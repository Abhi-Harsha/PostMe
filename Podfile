# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!

target 'PostMe' do

pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Alamofire', '~> 4.0’
pod 'SwiftSpinner'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

end
