// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalAddress _$TotalAddressFromJson(Map<String, dynamic> json) {
  return TotalAddress(
    json['address_name'] as String,
    _$enumDecodeNullable(_$AddressTypeEnumMap, json['address_type']),
    stringToDouble(json['x']),
    stringToDouble(json['y']),
    json['address'] == null
        ? null
        : Address.fromJson(json['address'] as Map<String, dynamic>),
    json['road_address'] == null
        ? null
        : RoadAddress.fromJson(json['road_address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TotalAddressToJson(TotalAddress instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('address_name', instance.addressName);
  writeNotNull('address_type', _$AddressTypeEnumMap[instance.addressType]);
  writeNotNull('address', instance.address);
  writeNotNull('road_address', instance.roadAddress);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$AddressTypeEnumMap = {
  AddressType.REGION: 'REGION',
  AddressType.ROAD: 'ROAD',
  AddressType.REGION_ADDR: 'REGION_ADDR',
  AddressType.ROAD_ADDR: 'ROAD_ADDR',
};
