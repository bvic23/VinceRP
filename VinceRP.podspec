Pod::Spec.new do |s|

  s.name         = 'VinceRP'
  s.version      = '0.2.4'
  s.summary      = 'Easy to use, easy to extend reactive framework for Swift.'

  s.description  = <<-DESC
  Easy to use, easy to extend reactive framework for Swift. If you are bored of doing MVC over and over give VinceRP a try.
                   DESC

  s.homepage     = 'https://github.com/bvic23/VinceRP'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { 'bvic23' => 'bvic23@gmail.com' }
  s.social_media_url   = 'http://twitter.com/bvic23'
  s.platform     = :ios, :osx

  s.source       = { :git => 'https://github.com/bvic23/VinceRP.git', :tag => s.version.to_s }

  s.source_files  = 'VinceRP/Common/**/*.{swift,h,m}', 'VinceRP/Extension/Common/**/*.{swift}'

  s.ios.deployment_target = '8.0'
  s.ios.source_files = 'VinceRP/Extension/UIKit/*.{swift}',

  s.osx.deployment_target = '10.10'
  s.osx.source_files = 'VinceRP/Extension/AppKit/*.{swift}'

end
