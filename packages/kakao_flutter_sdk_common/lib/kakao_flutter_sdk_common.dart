library;

export 'src/common_platform.dart';
export 'src/extension/map.dart';
export 'src/extension/string.dart';
export 'src/kakao_sdk.dart';
export 'src/model/kakao_api_exception.dart';
export 'src/model/kakao_apps_exception.dart';
export 'src/model/kakao_auth_exception.dart';
export 'src/model/kakao_client_exception.dart';
export 'src/model/kakao_exception.dart';
export 'src/model/platform_data.dart';
export 'src/model/platform_info.dart';
export 'src/network/kakao_dio_http_client.dart';
export 'src/network/kakao_http_client.dart';
export 'src/network/kakao_http_client_factory.dart';
export 'src/sdk_log.dart';
export 'src/server_hosts.dart';
export 'src/util.dart';
export 'src/util/cipher/aes_gcm_cipher.dart';
export 'src/util/cipher/cipher.dart';
export 'src/util/cipher/legacy_aes_cbc_cipher.dart';
export 'src/web/browser_detector.dart';
export 'src/web/web_utility_stub.dart' // 테스트 환경에서 웹 전용 구현이 포함되면 컴파일/로딩 단계에서 에러 발생.
    if (dart.library.html) 'src/web/web_utility.dart'; // 웹 환경에서만 웹 관련 코드가 동작하도록 처리.
