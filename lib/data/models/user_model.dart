import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel{
  String email;
  String username;
  String role;
  String id;
  final String avatarUrl;
  final String backgroundUrl;

  UserModel({
    required this.username,
    required this.email,
    required this.role,
    this.avatarUrl = 'https://via.placeholder.com/150',
    this.backgroundUrl = 'https://via.placeholder.com/800x400',
    required this.id
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}