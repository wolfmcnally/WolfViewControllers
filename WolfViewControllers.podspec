Pod::Spec.new do |s|
    s.name             = 'WolfViewControllers'
    s.version          = '4.0.1'
    s.summary          = 'Direct subclasses of iOS view controllers implementing useful patterns.'

    s.homepage         = 'https://github.com/wolfmcnally/WolfViewControllers'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/WolfViewControllers.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.source_files = 'Sources/WolfViewControllers/**/*'

    s.ios.deployment_target = '12.0'
    s.tvos.deployment_target = '12.0'

    s.module_name = 'WolfViewControllers'

    s.dependency 'WolfLog'
    s.dependency 'WolfCore'
    s.dependency 'WolfLocale'
    s.dependency 'WolfViews'
end
