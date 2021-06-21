source 'https://10.11.13.105/hlpods/HLSpecs.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '12.1'
inhibit_all_warnings!
use_modular_headers!

target 'SwiftiOS' do
  
  pod "FluentDarkModeKit"
  pod 'GRDB.swift'
  pod 'SwiftIconFont'
  pod 'Alamofire'
  pod 'HLLoggerModule'
  pod 'CalendarKit'
  pod 'lottie-ios'
  pod 'Cache'
  pod 'SnapKit'
  pod 'MagazineLayout'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
