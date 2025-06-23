// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'continent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Continent _$ContinentFromJson(Map<String, dynamic> json) => Continent(
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String,
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ContinentToJson(Continent instance) => <String, dynamic>{
  'name': instance.name,
  'imageUrl': instance.imageUrl,
  'location': instance.location,
};
