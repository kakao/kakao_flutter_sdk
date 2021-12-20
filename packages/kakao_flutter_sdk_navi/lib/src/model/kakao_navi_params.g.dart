// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_navi_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoNaviParams _$KakaoNaviParamsFromJson(Map<String, dynamic> json) {
  return KakaoNaviParams(
    destination: Location.fromJson(json['destination'] as Map<String, dynamic>),
    option: json['option'] == null
        ? null
        : NaviOption.fromJson(json['option'] as Map<String, dynamic>),
    viaList: (json['via_list'] as List<dynamic>?)
        ?.map((e) => Location.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$KakaoNaviParamsToJson(KakaoNaviParams instance) {
  final val = <String, dynamic>{
    'destination': instance.destination.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('option', instance.option?.toJson());
  writeNotNull('via_list', instance.viaList?.map((e) => e.toJson()).toList());
  return val;
}
