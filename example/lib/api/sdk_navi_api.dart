import 'package:example/model/list_item.dart';
import 'package:example/util/log.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

const String _tag = "NaviApi";

final naviApis = <ListItem>[
  const Header(_tag),
  Api('isKakaoNaviInstalled', (context) async {
    // 카카오내비 설치여부 조회
    final bool result = await NaviApi.instance.isKakaoNaviInstalled();

    final String msg = result ? '카카오내비 앱으로 길안내 가능' : '카카오내비 미설치';
    Log.i(_tag, msg);
  }),
  Api('shareDestination - KATEC', showResult: false, (context) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      // 카카오내비 앱으로 목적지 공유 - KATEC
      await NaviApi.instance.shareDestination(
        destination: Location(name: '카카오 판교오피스', x: '321286', y: '533707'),
      );
    } else {
      // 카카오내비 설치 페이지로 이동
      await launchBrowser(Uri.parse(NaviApi.webNaviInstall));
    }
  }),
  Api('shareDestination - WGS84', showResult: false, (context) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      // 카카오내비 앱으로 목적지 공유 - WGS84
      await NaviApi.instance.shareDestination(
        destination: Location(
          name: '카카오 판교오피스',
          x: '127.108640',
          y: '37.402111',
        ),
        option: NaviOption(coordType: CoordType.wgs84),
      );
    } else {
      await launchBrowser(Uri.parse(NaviApi.webNaviInstall));
    }
  }),
  Api('navigate - KATEC - viaList', showResult: false, (context) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      // 카카오내비 앱으로 목적지 공유 - KATEC - 경유지 추가
      await NaviApi.instance.navigate(
        destination: Location(name: '카카오 판교오피스', x: '321286', y: '533707'),
        viaList: [Location(name: '판교역 1번출구', x: '321525', y: '532951')],
      );
    } else {
      await launchBrowser(Uri.parse(NaviApi.webNaviInstall));
    }
  }),
  Api('navigate - WGS84 - viaList', showResult: false, (context) async {
    if (await NaviApi.instance.isKakaoNaviInstalled()) {
      // 카카오내비 앱으로 목적지 공유 - WGS84 - 경유지 추가
      await NaviApi.instance.navigate(
        destination: Location(
          name: '카카오 판교오피스',
          x: '127.108640',
          y: '37.402111',
        ),
        viaList: [Location(name: '판교역 1번출구', x: '127.111492', y: '37.395225')],
        option: NaviOption(coordType: CoordType.wgs84),
      );
    } else {
      await launchBrowser(Uri.parse(NaviApi.webNaviInstall));
    }
  }),
];
