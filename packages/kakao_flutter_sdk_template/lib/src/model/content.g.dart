// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      title: json['title'] as String?,
      imageUrl: json['image_url'] == null
          ? null
          : Uri.parse(json['image_url'] as String),
      link: Link.fromJson(json['link'] as Map<String, dynamic>),
      description: json['description'] as String?,
      imageWidth: (json['image_width'] as num?)?.toInt(),
      imageHeight: (json['image_height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      if (instance.title case final value?) 'title': value,
      if (instance.imageUrl?.toString() case final value?) 'image_url': value,
      'link': instance.link.toJson(),
      if (instance.description case final value?) 'description': value,
      if (instance.imageWidth case final value?) 'image_width': value,
      if (instance.imageHeight case final value?) 'image_height': value,
    };
