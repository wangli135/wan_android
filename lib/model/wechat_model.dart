import 'package:json_annotation/json_annotation.dart';

part 'wechat_model.g.dart';

/**
 * 公众号Item
 */
@JsonSerializable()
class WeChatItem {
  int id;
  String name;

  WeChatItem({this.id, this.name});

  factory WeChatItem.fromJson(Map<String, dynamic> json) =>
      _$WeChatItemFromJson(json);

  Map<String, dynamic> toJson() => _$WeChatItemToJson(this);
}

@JsonSerializable()
class WeChatReponse {
  int errorCode;
  String errorMsg;
  List<WeChatItem> data;

  WeChatReponse({this.errorCode, this.errorMsg, this.data});

  factory WeChatReponse.fromJson(Map<String, dynamic> json) =>
      _$WeChatReponseFromJson(json);

  Map<String, dynamic> toJson() => _$WeChatReponseToJson(this);
}
