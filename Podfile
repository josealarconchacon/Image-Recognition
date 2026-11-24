platform :ios, '15.0'

target 'ImageRecognition' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ImageRecognition
	pod 'Firebase/Core'
	pod 'Firebase/Storage'
	pod 'Firebase/Auth'
	pod 'Firebase/Firestore'
	pod 'Kingfisher', '~> 8.0'
	pod 'DropDown'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Some pods still declare older minimums, which current Xcode rejects.
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
