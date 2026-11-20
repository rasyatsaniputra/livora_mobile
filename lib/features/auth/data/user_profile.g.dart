// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: _idFromJson(json['id']),
  email: json['email'] as String,
  username: json['username'] as String,
  noHp: json['no_hp'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'no_hp': instance.noHp,
      'role': instance.role,
    };
