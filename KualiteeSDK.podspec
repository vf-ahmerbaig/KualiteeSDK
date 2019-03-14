Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "KualiteeSDK"
s.summary = "KualiteeSDK lets a user add QA ability to applications."
s.requires_arc = true

# 2
s.version = "0.1.3"

# 3
s.license = { :type => "MIT", :file => "MIT License" }

# 4 - Replace with your name and e-mail address
s.author = { "D3v!OS" => "ahmer.baig@virtualforce.io" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/vf-ahmerbaig/KualiteeSDK"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/vf-ahmerbaig/KualiteeSDK.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'AWSS3'
s.dependency 'AWSMobileClient'

# 8
s.source_files = "KualiteeSDK/**/*.{swift}"

# 9
s.resources = "KualiteeSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
