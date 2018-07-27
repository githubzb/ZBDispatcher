Pod::Spec.new do |s|
  s.name         = "ZBDispatcher"
  s.version      = "0.0.1"
  s.summary      = "Objective-C scheduling decoupling class."
  s.description  = <<-DESC
                    This is a Objective-C scheduling decoupling class.
                   DESC
  s.homepage     = "https://github.com/githubzb/ZBDispatcher"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "dr.box" => "1126976340@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/githubzb/ZBDispatcher.git", :tag => "#{s.version}" }
  s.source_files = "#{s.name}/Resource/**/*.{h,m}"
  s.requires_arc = true
  
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
