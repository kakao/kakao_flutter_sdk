#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'kakao_flutter_sdk'
  s.version          = '0.8.2'
  s.summary          = 'Flutter SDK for Kakao API'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/kakao/kakao_flutter_sdk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hara Kang' => 'hara0115@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
end

