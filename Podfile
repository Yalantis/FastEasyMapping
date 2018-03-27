inhibit_all_warnings!
use_frameworks!

abstract_target 'Tests' do
    pod 'Kiwi', '~> 2.4.0'
    pod 'CMFactory', '~> 1.4.0'
    pod 'MagicalRecord', '~> 2.3'
    pod 'OCMock', '~> 3.4'

    pod 'Nimble', '7.0'
    pod 'Quick', '~> 1.0'

    target 'FastEasyMapping iOS Tests' do
      platform :ios, :deployment_target => '8.0'
    end

    target 'FastEasyMapping macOS Tests' do
      platform :osx, :deployment_target => '10.10'    end

    # Kiwi, CMFactory and MagicalRecord do not support tvOS targets / specs.
    # No way to integrat them into tvOS tests :-/
    # target 'FastEasyMapping tvOS Tests' do
    #   platform :tvos, :deployment_target => '9.0'
    # end
end

target 'Benchmark' do
    platform :osx, :deployment_target => '10.10'

    pod 'MagicalRecord', '~> 2.3'
end
