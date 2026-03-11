import 'package:flutter_test/flutter_test.dart';
import 'package:kakao_flutter_sdk_navi/src/model/kakao_navi_params.dart';
import 'package:kakao_flutter_sdk_navi/src/model/location.dart';
import 'package:kakao_flutter_sdk_navi/src/model/navi_option.dart';

void main() {
  test('NaviOption serializes enum and special keys', () {
    final option = NaviOption(
      coordType: CoordType.katec,
      vehicleType: VehicleType.second,
      rpOption: RpOption.recommended,
      routeInfo: true,
      startX: '12345',
      startY: '67890',
      startAngle: 45,
      returnUri: 'kakaonavi://return',
    );

    final json = option.toJson();
    expect(json['coord_type'], 'katec');
    expect(json['vehicle_type'], '2');
    expect(json['rpoption'], '100');
    expect(json['route_info'], true);
    expect(json['s_x'], '12345');
    expect(json['s_y'], '67890');
    expect(json['start_angle'], 45);
    expect(json['return_uri'], 'kakaonavi://return');

    final decoded = NaviOption.fromJson(json);
    expect(decoded.coordType, CoordType.katec);
    expect(decoded.vehicleType, VehicleType.second);
    expect(decoded.rpOption, RpOption.recommended);
  });

  test('NaviOption clone keeps original and overrides requested fields', () {
    final original = NaviOption(
      coordType: CoordType.wgs84,
      vehicleType: VehicleType.first,
      routeInfo: false,
    );

    final cloned = original.clone(routeInfo: true, startAngle: 90);
    expect(cloned.coordType, CoordType.wgs84);
    expect(cloned.vehicleType, VehicleType.first);
    expect(cloned.routeInfo, true);
    expect(cloned.startAngle, 90);
  });

  test('KakaoNaviParams serializes destination, option, and viaList', () {
    final params = KakaoNaviParams(
      destination: Location(name: '목적지', x: '321286', y: '533707'),
      option: NaviOption(rpOption: RpOption.fast),
      viaList: [
        Location(name: '경유지 1', x: '100000', y: '200000'),
        Location(name: '경유지 2', x: '110000', y: '210000'),
      ],
    );

    final json = params.toJson();
    expect(json['destination'], {'name': '목적지', 'x': '321286', 'y': '533707'});
    expect(json['option'], {'rpoption': '1'});
    expect(json['via_list'], [
      {'name': '경유지 1', 'x': '100000', 'y': '200000'},
      {'name': '경유지 2', 'x': '110000', 'y': '210000'},
    ]);

    final decoded = KakaoNaviParams.fromJson(json);
    expect(decoded.destination.name, '목적지');
    expect(decoded.viaList, hasLength(2));
    expect(decoded.option?.rpOption, RpOption.fast);
  });
}
