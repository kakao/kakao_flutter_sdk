// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navi_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NaviOption _$NaviOptionFromJson(Map<String, dynamic> json) => NaviOption(
      coordType: $enumDecodeNullable(_$CoordTypeEnumMap, json['coord_type']),
      vehicleType:
          $enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicle_type']),
      rpOption: $enumDecodeNullable(_$RpOptionEnumMap, json['rpoption']),
      routeInfo: json['route_info'] as bool?,
      startX: json['s_x'] as String?,
      startY: json['s_y'] as String?,
      startAngle: json['start_angle'] as int?,
      returnUri: json['return_uri'] as String?,
    );

Map<String, dynamic> _$NaviOptionToJson(NaviOption instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coord_type', _$CoordTypeEnumMap[instance.coordType]);
  writeNotNull('vehicle_type', _$VehicleTypeEnumMap[instance.vehicleType]);
  writeNotNull('rpoption', _$RpOptionEnumMap[instance.rpOption]);
  writeNotNull('route_info', instance.routeInfo);
  writeNotNull('s_x', instance.startX);
  writeNotNull('s_y', instance.startY);
  writeNotNull('start_angle', instance.startAngle);
  writeNotNull('return_uri', instance.returnUri);
  return val;
}

const _$CoordTypeEnumMap = {
  CoordType.wgs84: 'wgs84',
  CoordType.katec: 'katec',
};

const _$VehicleTypeEnumMap = {
  VehicleType.first: '1',
  VehicleType.second: '2',
  VehicleType.third: '3',
  VehicleType.fourth: '4',
  VehicleType.fifth: '5',
  VehicleType.sixth: '6',
  VehicleType.twoWheel: '7',
};

const _$RpOptionEnumMap = {
  RpOption.fast: '1',
  RpOption.free: '2',
  RpOption.shortest: '3',
  RpOption.noAuto: '4',
  RpOption.wide: '5',
  RpOption.highway: '6',
  RpOption.normal: '8',
  RpOption.recommended: '100',
};
