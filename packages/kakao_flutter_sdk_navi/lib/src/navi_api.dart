import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';

import 'model/kakao_navi_params.dart';
import 'model/location.dart';
import 'model/navi_option.dart';
import 'navi_platform.dart';

/// KO: 카카오내비 API 클라이언트
/// <br>
/// EN: Client for the Kakao Navi APIs
class NaviApi {
  /// @nodoc
  NaviApi({NaviPlatform? platform})
    : _platform = platform ?? NaviPlatform.instance;

  final NaviPlatform _platform;

  /// @nodoc
  static final NaviApi instance = NaviApi();

  /// @nodoc
  static String get webNaviInstall => KakaoSdk.platform.web.kakaoNaviInstallPage;

  /// KO: 카카오내비 앱 실행 가능 여부 조회
  /// <br>
  /// EN: Check whether the Kakao Navi app is available

  Future<bool> isKakaoNaviInstalled() {
    return _platform.isKakaoNaviInstalled().then((installed) {
      SdkLog.i(
        '[NaviApi.isKakaoNaviInstalled] completed | installed=$installed',
      );
      return installed;
    });
  }

  /// KO: 카카오내비 앱으로 길안내 실행, 모바일 기기에서만 동작<br>
  /// [destination]에 목적지 전달<br>
  /// [option]에 경로 검색 옵션 전달<br>
  /// [viaList]에 경유지 목록 전달(최대: 3개)<br>
  /// <br>
  /// EN: Launches the Kakao Navi app to start navigation, available only on the mobile devices<br>
  /// Pass the destination to [destination]<br>
  /// Pass the options for searching the route to [option]<br>
  /// Pass the list of stops to [viaList] (Maximum: 3 places)
  Future<void> navigate({
    required Location destination,
    NaviOption? option,
    List<Location>? viaList,
  }) {
    SdkLog.d(
      '[NaviApi.navigate] started | destination=${destination.name} viaCount=${viaList?.length ?? 0} hasOption=${option != null}',
    );
    final params = KakaoNaviParams(
      destination: destination,
      option: option,
      viaList: viaList,
    );

    return _platform.navigate(params);
  }

  /// KO: 카카오내비 앱으로 목적지 공유 실행, 모바일 기기에서만 동작<br>
  /// [destination]에 목적지 전달<br>
  /// [option]에 경로 검색 옵션 전달<br>
  /// [viaList]에 경유지 목록 전달(최대: 3개)<br>
  /// <br>
  /// EN: Launches the Kakao Navi app to show the shared destination, available only on the mobile devices<br>
  /// Pass the destination to [destination]<br>
  /// Pass the options for searching the route to [option]<br>
  /// Pass the list of stops to [viaList] (Maximum: 3 places)
  Future<void> shareDestination({
    required Location destination,
    NaviOption? option,
    List<Location>? viaList,
  }) {
    final shareOption = option?.clone(routeInfo: true);
    SdkLog.d(
      '[NaviApi.shareDestination] started | destination=${destination.name} viaCount=${viaList?.length ?? 0} hasOption=${option != null}',
    );

    final params = KakaoNaviParams(
      destination: destination,
      option: shareOption,
      viaList: viaList,
    );

    return _platform.navigate(params);
  }
}
