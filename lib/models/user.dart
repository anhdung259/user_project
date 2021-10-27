import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? avatarUrl;
  String? htmlUrl;
  String? name;
  int? repos;
  int? followers;
  int? following;
  String? bio;
  String? login;
  String? location;

  User(
      {this.id,
      this.name,
      this.avatarUrl,
      this.htmlUrl,
      this.followers,
      this.following,
      this.bio,
      this.repos,
      this.login,
      this.location});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
