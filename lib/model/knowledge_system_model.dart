import 'package:json_annotation/json_annotation.dart';

part 'knowledge_system_model.g.dart';

/**
 * 知识体系中的一个点
 */
@JsonSerializable()
class KnowledgeItem {
  int id;
  String name;

  KnowledgeItem({this.id, this.name});

  factory KnowledgeItem.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeItemFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeItemToJson(this);
}

/**
 * 知识体系中的一个分类
 */
@JsonSerializable()
class KnowledgeCategory {
  int courseId;
  String name;
  int id;
  List<KnowledgeItem> children;

  KnowledgeCategory({this.courseId, this.name, this.id, this.children});

  factory KnowledgeCategory.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeCategoryToJson(this);
}

@JsonSerializable()
class KnowledgeSytemResponse {
  int errorCode;
  String errorMsg;
  List<KnowledgeCategory> data;

  KnowledgeSytemResponse(this.errorCode, this.errorMsg, this.data);

  factory KnowledgeSytemResponse.fromJson(Map<String, dynamic> json) =>
      _$KnowledgeSytemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$KnowledgeSytemResponseToJson(this);
}
