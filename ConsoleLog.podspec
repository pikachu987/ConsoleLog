Pod::Spec.new do |s|
  s.name             = 'ConsoleLog'
  s.version          = '0.1.1'
  s.summary          = 'You can create and view your app log.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
You can easily view your app logs while your app is running.
You can print the app log and create app logs.
You can see crash critics.
                    DESC

  s.homepage         = 'https://github.com/pikachu987/ConsoleLog'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pikachu987' => 'pikachu77769@gmail.com' }
  s.source           = { :git => 'https://github.com/pikachu987/ConsoleLog.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'
  s.source_files = 'ConsoleLog/Classes/**/*'
  # s.resource_bundles = {
  #   'ConsoleLog' => ['ConsoleLog/Assets/*.png']
  # }
  s.frameworks = 'UIKit'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
