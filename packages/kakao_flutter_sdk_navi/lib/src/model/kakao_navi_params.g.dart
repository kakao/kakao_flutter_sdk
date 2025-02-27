// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kakao_navi_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KakaoNaviParams _$KakaoNaviParamsFromJson(Map<String, dynamic> json) =>
    KakaoNaviParams(
      destination:
          Location.fromJson(json['destination'] as Map<String, dynamic>),
      option: json['option'] == null
          ? null
          : NaviOption.fromJson(json['option'] as Map<String, dynamic>),
      viaList: (json['via_list'] as List<dynamic>?)
          ?.map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KakaoNaviParamsToJson(KakaoNaviParams instance) =>
    <String, dynamic>{
      'destination': instance.destination.toJson(),
      if (instance.option?.toJson() case final value?) 'option': value,
      if (instance.viaList?.map((e) => e.toJson()).toList() case final value?)
        'via_list': value,
    };
