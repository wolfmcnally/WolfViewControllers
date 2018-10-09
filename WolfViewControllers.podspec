Pod::Spec.new do |s|
    s.name             = 'WolfViewControllers'
    s.version          = '1.0.3'
    s.summary          = 'Direct subclasses of iOS view controllers implementing useful patterns.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfViewControllers'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfViewControllers.git', :tag => s.version.to_s }

    s.swift_version = '4.2'

    s.source_files = 'WolfViewControllers/Classes/**/*'

    s.ios.deployment_target = '9.3'
    s.tvos.deployment_target = '11.0'

    s.module_name = 'WolfViewControllers'

    s.dependency 'WolfLog'
    s.dependency 'WolfNesting'
    s.dependency 'WolfStrings'
    s.dependency 'WolfLocale'
    s.dependency 'WolfConcurrency'
    s.dependency 'WolfFoundation'
    s.dependency 'WolfViews'
end
