// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    admin: json['admin'] as bool,
    id: json['id'] as int,
    nickname: json['nickname'] as String,
    token: json['token'] as String,
    username: json['username'] as String,
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'admin': instance.admin,
      'id': instance.id,
      'nickname': instance.nickname,
      'token': instance.token,
      'username': instance.username,
      'icon': instance.icon,
    };

BaseModel _$RegisterModelFromJson(Map<String, dynamic> json) {
  return BaseModel(
    errorCode: json['errorCode'] as int,
    errorMsg: json['errorMsg'] as String,
    data: json['data'] == null
        ? null
        : UserData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$RegisterModelToJson(BaseModel instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data,
    };
