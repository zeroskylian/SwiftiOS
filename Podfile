platform :ios, '12.1'
inhibit_all_warnings!
use_modular_headers!

target 'SwiftiOS' do
  
  pod "FluentDarkModeKit"
  pod 'GRDB.swift'
#  pod 'TXIMSDK_TUIKit_iOS' 
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end
