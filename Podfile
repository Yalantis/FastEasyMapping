inhibit_all_warnings!
use_frameworks!

def test_pods
    pod 'Kiwi', '3.0.0'
    pod 'CMFactory', '1.4.1'
    pod 'MagicalRecord', '2.3.2'
    pod 'OCMock', '3.4.3'
    pod 'Nimble', '8.0.4'
    pod 'Quick', '2.1.0'
end

target 'FastEasyMapping iOS Tests' do
  platform :ios, :deployment_target => '8.0'
  test_pods
end

target 'FastEasyMapping macOS Tests' do
  platform :osx, :deployment_target => '10.10'
  test_pods
end

target 'Benchmark' do
    platform :osx, :deployment_target => '10.10'
    pod 'MagicalRecord', '2.3.2'
end
