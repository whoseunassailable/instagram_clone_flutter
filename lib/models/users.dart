// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.username,
    required this.photoUrl,
  });

  String id;
  String bio;
  String email;
  List<dynamic> followers;
  List<dynamic> following;
  String username;
  String photoUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        bio: json["bio"],
        email: json["email"],
        followers: List<dynamic>.from(json["followers"].map((x) => x)),
        following: List<dynamic>.from(json["following"].map((x) => x)),
        username: json["username"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "bio": bio,
        "email": email,
        "followers": List<dynamic>.from(followers.map((x) => x)),
        "following": List<dynamic>.from(following.map((x) => x)),
        "username": username,
        "photoUrl": photoUrl,
      };
}
