import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:web/web.dart';

import '../common_platform.dart';
import '../model/platform_data.dart';
import '../network/kakao_dio_http_client.dart';
import '../network/kakao_http_client.dart';
import 'web_utility.dart';

/// @nodoc
class CommonPlatformImpl extends CommonPlatform {
  @override
  Future<PlatformData> getPlatformData() async {
    final platformData = PlatformData(
      platformId: _getPlatformId(),
      origin: _getOrigin(),
      kaHeader: _getKaHeader(),
      appVer: await _getAppVersion(),
      packageName: null,
    );
    return Future.value(platformData);
  }

  @override
  Future<bool> isAppInstalled({String? packageName, String? appScheme}) {
    // 웹에서는 앱 설치 여부를 알 수 없으므로 모바일 환경이면 true 반환
    return Future.value(isMobileWeb());
  }

  @override
  Future<bool> isKakaoTalkAvailable(String? appScheme) {
    return isAppInstalled();
  }

  @override
  Future<void> launchUrl(String url, {bool useBrowserSession = false}) {
    // useBrowserSession은 ios에서만 사용
    return Future.sync(() => _windowOpen(url, '_blank'));
  }

  Uint8List _getPlatformId() {
    final origin = Uri.parse(
      window.location.origin,
    ).authority.split('').map((e) => e.codeUnits[0]).toList();
    final end = origin.length >= 10 ? 10 : origin.length;
    return Uint8List.fromList(origin.sublist(0, end));
  }

  String _getOrigin() {
    return window.location.origin;
  }

  String _getKaHeader() {
    return 'os/javascript origin/${window.location.origin}';
  }

  Future<String> _getAppVersion() async {
    final json = await _getVersionJson();
    return json['version'] ?? 'unknown';
  }

  Window? _windowOpen(String url, String name, {String features = ''}) {
    return window.open(url, name, features);
  }

  Future<Map<String, String>> _getVersionJson() async {
    final cacheBuster = DateTime.now().millisecondsSinceEpoch;

    final String baseUri = window.document.baseURI;
    final client = _createHttpClient(baseUrl: baseUri);
    final response = await client.get(
      'version.json',
      queryParameters: {'cachebuster': cacheBuster},
    );
    return response.data;
  }

  KakaoHttpClient _createHttpClient({String? baseUrl}) {
    final options = baseUrl != null ? BaseOptions(baseUrl: baseUrl) : null;
    return KakaoDioHttpClient(options: options);
  }

  @override
  void setDeepLinkCallback(Function(String url)? callback) {
    // 웹은 딥링크 콜백 미지원
  }
}
