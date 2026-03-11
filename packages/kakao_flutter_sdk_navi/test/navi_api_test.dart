import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_navi/src/model/location.dart';
import 'package:kakao_flutter_sdk_navi/src/model/navi_option.dart';
import 'package:kakao_flutter_sdk_navi/src/navi_api.dart';

import 'support/doubles/fake_navi_platform.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NaviApi', () {
    late FakeNaviPlatform fakePlatform;

    setUp(() {
      fakePlatform = FakeNaviPlatform();
    });

    tearDown(() {});

    test('should return whether Kakao Navi is installed', () async {
      final naviApi = NaviApi(platform: fakePlatform);

      // 앱이 설치되지 않은 경우
      fakePlatform.isInstalled = false;
      expect(await naviApi.isKakaoNaviInstalled(), false);

      // 앱이 설치된 경우
      fakePlatform.isInstalled = true;
      expect(await naviApi.isKakaoNaviInstalled(), true);
    });

    test('should start navigation with a destination', () async {
      final naviApi = NaviApi(platform: fakePlatform);

      final destination = Location(
        name: '카카오 판교 오피스',
        x: '321286',
        y: '533707',
      );

      await naviApi.navigate(destination: destination);

      expect(fakePlatform.navigateCalls, hasLength(1));
      final params = fakePlatform.navigateCalls.single;

      expect(params.destination.name, '카카오 판교 오피스');
      expect(params.destination.x, '321286');
      expect(params.destination.y, '533707');
      expect(params.viaList, isNull);
      expect(params.option, isNull);
    });

    test('should include waypoints and options when navigating', () async {
      final naviApi = NaviApi(platform: fakePlatform);

      final destination = Location(name: '목적지', x: '321286', y: '533707');

      final viaList = [
        Location(name: '경유지 1', x: '100000', y: '200000'),
        Location(name: '경유지 2', x: '110000', y: '210000'),
      ];

      final option = NaviOption(
        coordType: CoordType.wgs84,
        vehicleType: VehicleType.first,
        rpOption: RpOption.fast,
      );

      await naviApi.navigate(
        destination: destination,
        viaList: viaList,
        option: option,
      );

      expect(fakePlatform.navigateCalls, hasLength(1));
      final params = fakePlatform.navigateCalls.single;

      expect(params.destination.name, '목적지');
      expect(params.viaList, isNotNull);
      expect(params.viaList, hasLength(2));
      expect(params.viaList![0].name, '경유지 1');
      expect(params.viaList![1].name, '경유지 2');

      expect(params.option, isNotNull);
      expect(params.option!.coordType, CoordType.wgs84);
      expect(params.option!.vehicleType, VehicleType.first);
      expect(params.option!.rpOption, RpOption.fast);
    });

    test('should force routeInfo to true when sharing a destination', () async {
      final naviApi = NaviApi(platform: fakePlatform);

      final destination = Location(
        name: '카카오 판교 오피스',
        x: '321286',
        y: '533707',
      );

      final option = NaviOption(
        coordType: CoordType.wgs84,
        vehicleType: VehicleType.first,
        routeInfo: false, // false로 설정해도
      );

      final viaList = [Location(name: '경유지 1', x: '100000', y: '200000')];

      await naviApi.shareDestination(
        destination: destination,
        option: option,
        viaList: viaList,
      );

      expect(fakePlatform.navigateCalls, hasLength(1));
      final params = fakePlatform.navigateCalls.single;

      // shareDestination은 항상 routeInfo를 true로 설정
      expect(params.option, isNotNull);
      expect(params.option!.routeInfo, true);

      // 나머지 옵션은 유지
      expect(params.option!.coordType, CoordType.wgs84);
      expect(params.option!.vehicleType, VehicleType.first);

      // viaList는 전달되어야 함
      expect(params.viaList, isNotNull);
      expect(params.viaList, hasLength(1));
      expect(params.viaList!.single.name, '경유지 1');
    });
  });
}
