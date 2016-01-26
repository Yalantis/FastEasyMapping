Pod::Spec.new do |spec|
  spec.name         = 'FastEasyMapping'
  spec.version      = '1.0.1'
  spec.summary      = 'Fast mapping from JSON to NSObject / NSManagedObject and back'
  spec.homepage     = "https://github.com/Yalantis/FastEasyMapping"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Dmitriy Zen' => 'zen.dev@yandex.com' }
  spec.source       = { :git => 'https://github.com/Yalantis/FastEasyMapping.git', :tag => spec.version }

  spec.requires_arc = true
  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'
  spec.tvos.deployment_target = '9.0'
  spec.frameworks = 'CoreData'

  spec.source_files = 'FastEasyMapping/Source/**/*.{h,m}'
  spec.private_header_files = 'FastEasyMapping/Source/Extensions/**/*.h'
end
