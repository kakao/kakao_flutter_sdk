// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navi_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NaviOption _$NaviOptionFromJson(Map<String, dynamic> json) {
  return NaviOption(
    _$enumDecodeNullable(_$CoordTypeEnumMap, json['coord_type']),
    _$enumDecodeNullable(_$VehicleTypeEnumMap, json['vehicle_type']),
    _$enumDecode(_$RpOptionEnumMap, json['rpoption']),
    json['route_info'] as bool?,
    json['s_x'] as String?,
    json['s_y'] as String?,
    json['start_angle'] as int?,
    json['return_uri'] as String?,
  );
}

Map<String, dynamic> _$NaviOptionToJson(NaviOption instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coord_type', _$CoordTypeEnumMap[instance.coordType]);
  writeNotNull('vehicle_type', _$VehicleTypeEnumMap[instance.vehicleType]);
  val['rpoption'] = _$RpOptionEnumMap[instance.rpOption];
  writeNotNull('route_info', instance.routeInfo);
  writeNotNull('s_x', instance.startX);
  writeNotNull('s_y', instance.startY);
  writeNotNull('start_angle', instance.startAngle);
  writeNotNull('return_uri', instance.returnUri);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$CoordTypeEnumMap = {
  CoordType.WGS84: 'wgs84',
  CoordType.KATEC: 'katec',
};

const _$VehicleTypeEnumMap = {
  VehicleType.FIRST: '1',
  VehicleType.SECOND: '2',
  VehicleType.THIRD: '3',
  VehicleType.FOURTH: '4',
  VehicleType.FIFTH: '5',
  VehicleType.SIXTH: '6',
  VehicleType.TWO_WHEEL: '7',
};

const _$RpOptionEnumMap = {
  RpOption.FAST: '1',
  RpOption.FREE: '2',
  RpOption.SHORTEST: '3',
  RpOption.NO_AUTO: '4',
  RpOption.WIDE: '5',
  RpOption.HIGHWAY: '6',
  RpOption.NORMAL: '8',
  RpOption.RECOMMENDED: '100',
};
