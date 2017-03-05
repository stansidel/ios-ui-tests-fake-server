# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  target 'MyAppUITests' do
    inherit! :search_paths
    # For the server to work properly on simulator we need an option to set the listening address to localhost
    # https://github.com/httpswift/swifter/pull/222
    # The latest Cocoapods repo version is 1.3.2 (as of 03/05/2017) which doesn't yet include it, so use the github version.
    pod 'Swifter', :git => 'https://github.com/httpswift/swifter.git', :branch => 'stable'
  end

end
