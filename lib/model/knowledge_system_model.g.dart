// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_system_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnowledgeItem _$KnowledgeItemFromJson(Map<String, dynamic> json) {
  return KnowledgeItem(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$KnowledgeItemToJson(KnowledgeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

KnowledgeCategory _$KnowledgeCategoryFromJson(Map<String, dynamic> json) {
  return KnowledgeCategory(
    courseId: json['courseId'] as int,
    name: json['name'] as String,
    id: json['id'] as int,
    children: (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : KnowledgeItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$KnowledgeCategoryToJson(KnowledgeCategory instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'name': instance.name,
      'id': instance.id,
      'children': instance.children,
    };

KnowledgeSytemResponse _$KnowledgeSytemResponseFromJson(
    Map<String, dynamic> json) {
  return KnowledgeSytemResponse(
    json['errorCode'] as int,
    json['errorMsg'] as String,
    (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : KnowledgeCategory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$KnowledgeSytemResponseToJson(
        KnowledgeSytemResponse instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data,
    };
