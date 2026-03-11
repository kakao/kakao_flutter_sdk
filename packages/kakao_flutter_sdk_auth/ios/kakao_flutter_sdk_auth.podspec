#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint kakao_flutter_sdk_auth.podspec` to validate before publishing.
#
require 'yaml'

pubspec = YAML.load_file(File.expand_path('../pubspec.yaml', __dir__))

Pod::Spec.new do |s|
  s.name             = pubspec['name']
  s.version          = pubspec['version']
  s.summary          = pubspec['description']
  s.description      = pubspec['description']
  s.homepage         = pubspec['homepage']
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kakao Developers' => 'kakaoplatformdevelopers@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'kakao_flutter_sdk_auth/Sources/kakao_flutter_sdk_auth/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.resource_bundles = {
    'kakao_flutter_sdk_auth_privacy' => ['kakao_flutter_sdk_auth/Sources/kakao_flutter_sdk_auth/Resources/PrivacyInfo.xcprivacy']
  }
end
