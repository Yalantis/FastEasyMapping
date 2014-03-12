Pod::Spec.new do |s|

  s.name         = "EasyMappingKit"
  s.version      = "0.1"
  s.summary      = "FAST EasyMapping fork"
  s.homepage     = "https://github.com/poteryaysya/EasyMapping"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Dmitriy Shemet" => "dmitriy.shemet@yalantis.com" }

  s.source       = { :git => "https://github.com/Yalantis/EasyMappingKit.git", :tag => "0.1" }

  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.7'
  s.frameworks = 'CoreData'

  s.source_files = 'EasyMappingKit/Source/**/*.{h,m}'

end
