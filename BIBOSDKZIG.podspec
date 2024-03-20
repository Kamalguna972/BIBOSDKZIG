Pod::Spec.new do |spec|
  spec.name         = "BIBOSDKZIG"
  spec.version      = "1.0.0"
  spec.summary      = "Framework for BIBOSDKZIG - A summary of what the framework does"
  spec.description  = "Detailed description of BIBOSDKZIG."
  spec.homepage     = "https://github.com/Kamalguna972/BIBOSDKZIG"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "kamalesh" => "kamalesh@zed.digital" }
  
  spec.platform     = :ios, "13.0" # Adjusted deployment target
  spec.source       = { :git => "https://github.com/Kamalguna972/BIBOSDKZIG.git", :tag => spec.version.to_s  }
  spec.source_files = "ZIGBIBOSDK/**/*.swift" # Adjusted source files pattern
  
  spec.swift_versions = "5.0" # Specified Swift version
  
  spec.dependency 'Alamofire', '~> 5.0' # Adjusted Alamofire version
end
