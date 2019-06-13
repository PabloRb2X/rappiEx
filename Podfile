# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def frameworks_pods
   pod 'Alamofire', '4.7.3'
   pod 'ObjectMapper', '3.4.1'
   pod 'AlamofireObjectMapper', '5.2.0'
end

target 'RappiEx' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RappiEx
  frameworks_pods

  target 'RappiExTests' do
    inherit! :search_paths
    # Pods for testing
    frameworks_pods
  end

  target 'RappiExUITests' do
    inherit! :search_paths
    # Pods for testing
    frameworks_pods
  end

end
