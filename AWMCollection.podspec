Pod::Spec.new do |spec|
  
  spec.name         = "AWMCollection"
  spec.version      = "0.0.1"
  spec.summary      = "A Lib For colletion vc."
  spec.description  = <<-DESC
  AWMCollection是colletion vc的封装
  DESC
  
  spec.homepage     = "https://github.com/StoneStoneStoneWang/AWMKit.git"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.author             = { "StoneStoneStoneWang" => "yuanxingfu1314@163.com" }
  spec.platform     = :ios, "10.0"
  spec.ios.deployment_target = "10.0"
  
  spec.swift_version = '5.0'
  
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  
  spec.static_framework = true
  
  spec.frameworks = 'UIKit', 'Foundation'
  
  spec.source = { :git => "https://github.com/StoneStoneStoneWang/AWMKit.git", :tag => "#{spec.version}" }
  
  spec.dependency 'AWMLoading'
  spec.dependency 'MJRefresh'
  
  spec.vendored_frameworks = 'Framework/AWMCollection/AWMCollection.framework'
  
end
