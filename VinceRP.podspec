Pod::Spec.new do |s|

  s.name         = "VinceRP"
  s.version      = "0.1.2"
  s.summary      = "Easy to use, easy to extend reactive framework for Swift."

  s.description  = <<-DESC
  Easy to use, easy to extend reactive framework for Swift.
                   DESC

  s.homepage     = "https://github.com/bvic23/VinceRP"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.author             = { "bvic23" => "bvic23@gmail.com" }
  s.social_media_url   = "http://twitter.com/bvic23"
  s.platform     = :ios, :osx

  s.source       = { :git => "https://github.com/bvic23/VinceRP.git", :tag => "0.1.2" }

  s.source_files  = "vincerp/**/*.{swift,h,m}"
  s.frameworks    = "Foundation"

  s.ios.deployment_target = "8.0"
  s.ios.source_files = "vincerp/Extension/UIKit/*.{swift}"
  s.ios.frameworks   = "UIKit"

  s.osx.deployment_target = "10.10"
  s.osx.frameworks   = "AppKit"

end
