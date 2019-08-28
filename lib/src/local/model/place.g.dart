// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return Place(
    json['id'] as String,
    json['place_name'] as String,
    json['category_name'] as String,
    _$enumDecodeNullable(_$CategoryGroupEnumMap, json['category_group_code'],
        unknownValue: CategoryGroup.UNKNOWN),
    json['category_group_name'] as String,
    json['phone'] as String,
    json['address_name'] as String,
    json['road_address_name'] as String,
    json['place_url'] == null ? null : Uri.parse(json['place_url'] as String),
    stringToInt(json['distance']),
    stringToDouble(json['x']),
    stringToDouble(json['y']),
  );
}

Map<String, dynamic> _$PlaceToJson(Place instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('x', instance.x);
  writeNotNull('y', instance.y);
  writeNotNull('id', instance.id);
  writeNotNull('place_name', instance.placeName);
  writeNotNull('category_name', instance.categoryName);
  writeNotNull('category_group_code',
      _$CategoryGroupEnumMap[instance.categoryGroupCode]);
  writeNotNull('category_group_name', instance.categoryGroupName);
  writeNotNull('phone', instance.phone);
  writeNotNull('address_name', instance.addressName);
  writeNotNull('road_address_name', instance.roadAddressName);
  writeNotNull('place_url', instance.placeUrl?.toString());
  writeNotNull('distance', instance.distance);
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

const _$CategoryGroupEnumMap = {
  CategoryGroup.MT1: 'MT1',
  CategoryGroup.CS2: 'CS2',
  CategoryGroup.PS3: 'PS3',
  CategoryGroup.SC4: 'SC4',
  CategoryGroup.AC5: 'AC5',
  CategoryGroup.PK6: 'PK6',
  CategoryGroup.OL7: 'OL7',
  CategoryGroup.SW8: 'SW8',
  CategoryGroup.BK9: 'BK9',
  CategoryGroup.CT1: 'CT1',
  CategoryGroup.AG2: 'AG2',
  CategoryGroup.PO3: 'PO3',
  CategoryGroup.AT4: 'AT4',
  CategoryGroup.AD5: 'AD5',
  CategoryGroup.FD6: 'FD6',
  CategoryGroup.CE7: 'CE7',
  CategoryGroup.HP8: 'HP8',
  CategoryGroup.PM9: 'PM9',
  CategoryGroup.UNKNOWN: 'UNKNOWN',
};
