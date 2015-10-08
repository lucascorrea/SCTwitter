#
#  Be sure to run `pod spec lint SCTwitter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SCTwitter"
  s.version      = "1.0"
  s.summary      = "A simple and clean to implement login to twitter using Blocks iOS - OAuth"

  s.description  = <<-DESC
                    A simple and clean to implement login to twitter using Blocks iOS - OAuth 
                    http://www.lucascorrea.com
                    DESC

  s.homepage     = "http://www.lucascorrea.com"
   s.license      = { :type => "MIT", :text => "SCTwitter is licensed under the MIT License" }

  s.author             = { "Lucas Correa" => "contato@lucascorrea.com" }
  s.platform     = :ios, "7.0"

  s.ios.deployment_target = "7.0"

  s.source       = { :git => "https://github.com/lucascorrea/SCTwitter.git", :tag => "1.0" }

  s.source_files  = "SCTwitter/**/SCTwitter.{h,m}"

  s.requires_arc = true

  s.frameworks = 'Accounts', 'CoreData', 'Social'


  # s.dependency 'TwitterKit'
  # s.dependency 'TwitterCore'

  s.dependency 'TwitterKit', '1.11.3'
  s.dependency 'TwitterCore', '1.11.3'

end
