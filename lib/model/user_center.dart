import 'package:json_annotation/json_annotation.dart';

part 'user_center.g.dart';

@JsonSerializable()
class UserData {
  bool admin;
  int id;
  String nickname;
  String token;
  String username;
  String icon;

  UserData(
      {this.admin,
      this.id,
      this.nickname,
      this.token,
      this.username,
      this.icon});

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}

@JsonSerializable()
class BaseModel {
  int errorCode;
  String errorMsg;
  UserData data;

  BaseModel({this.errorCode, this.errorMsg, this.data});

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);

  factory BaseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);
}
