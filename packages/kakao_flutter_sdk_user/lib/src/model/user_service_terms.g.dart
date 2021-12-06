// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_service_terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserServiceTerms _$UserServiceTermsFromJson(Map<String, dynamic> json) {
  return UserServiceTerms(
    json['user_id'] as int?,
    (json['allowed_service_terms'] as List<dynamic>?)
        ?.map((e) => ServiceTerms.fromJson(e as Map<String, dynamic>))
        .toList(),
  )..appServiceTerms = (json['app_service_terms'] as List<dynamic>?)
      ?.map((e) => AppServiceTerms.fromJson(e as Map<String, dynamic>))
      .toList();
}

Map<String, dynamic> _$UserServiceTermsToJson(UserServiceTerms instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('user_id', instance.userId);
  writeNotNull('allowed_service_terms',
      instance.allowedServiceTerms?.map((e) => e.toJson()).toList());
  writeNotNull('app_service_terms',
      instance.appServiceTerms?.map((e) => e.toJson()).toList());
  return val;
}
