part of 'AccountBase.dart';

AccountBase _$AccountBaseFromJson(Map<String, dynamic> json) {
  return AccountBase(
      json['url'] as String, json['bio'] as String, json['reputation'] as int);
}

Map<String, dynamic> _$AccountBaseToJson(AccountBase instance) =>
    <String, dynamic>{
      'url': instance.name,
      'bio': instance.bio,
      'reputation': instance.reputation
    };
