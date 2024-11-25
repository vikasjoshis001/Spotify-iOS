platform :ios, '15.0'

target 'Spotify-Clone' do
  use_frameworks!

  # Pods for Spotify-Clone
  pod 'SDWebImage'
  pod 'Appirater'
  pod 'Firebase/Analytics'
  
  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
              end
          end
      end
  end
end
