// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wechat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeChatItem _$WeChatItemFromJson(Map<String, dynamic> json) {
  return WeChatItem(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$WeChatItemToJson(WeChatItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

WeChatReponse _$WeChatReponseFromJson(Map<String, dynamic> json) {
  return WeChatReponse(
    errorCode: json['errorCode'] as int,
    errorMsg: json['errorMsg'] as String,
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : WeChatItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$WeChatReponseToJson(WeChatReponse instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data,
    };
