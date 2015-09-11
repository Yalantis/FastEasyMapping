platform :ios, :deployment_target => "7.0"
inhibit_all_warnings!

def import_tests
  pod 'Kiwi', '~> 2.4.0'
  pod 'CMFactory', '~> 1.4.0'
  pod 'MagicalRecord', '~> 2.3'
end

target :'FastEasyMappingTests', :exclusive => true do
  import_tests
  pod 'OCMock', '~> 3.1.5'
end

target :'FastEasyMappingRealmTests', :exclusive => true do
  import_tests
end
