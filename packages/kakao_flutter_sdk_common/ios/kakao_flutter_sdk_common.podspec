#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kakao_flutter_sdk_common.podspec` to validate before publishing.
#
require 'yaml'

pubspec = YAML.load_file(File.join('..', 'pubspec.yaml'))
library_version = pubspec['version'].gsub('+', '-')

Pod::Spec.new do |s|
  s.name             = 'kakao_flutter_sdk_common'
  s.version          = library_version
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/kakao/kakao_flutter_sdk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'tony.mb' => 'tony.mb@kakaocorp.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
  s.resource_bundles = {'kakao_flutter_sdk_common_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
