// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Destination _$DestinationFromJson(Map<String, dynamic> json) => Destination(
  json['ref'] as String,
  json['name'] as String,
  json['country'] as String,
  json['continent'] as String,
  json['knownFor'] as String,
  (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  json['imageUrl'] as String,
  Location.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DestinationToJson(Destination instance) =>
    <String, dynamic>{
      'ref': instance.ref,
      'name': instance.name,
      'country': instance.country,
      'continent': instance.continent,
      'knownFor': instance.knownFor,
      'tags': instance.tags,
      'imageUrl': instance.imageUrl,
      'location': instance.location,
    };

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  (json['latitude'] as num).toDouble(),
  (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
