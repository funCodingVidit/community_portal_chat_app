import 'dart:convert';

class User {
  String? get id => _id;
  String? username;
  String? photoUrl;
  String? _id;
  bool? active;
  DateTime? lastseen;

  User({
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.lastseen});

  toJson() => {
      'username': username,
      'photo_url': photoUrl,
      'active': active,
      'last_seen': lastseen
    };

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json['username'] ?? "",
      photoUrl: json['photo_url'] ?? "",
      active: json['active'] ?? false,
      lastseen: json['last_seen'] ?? DateTime.now());
    user._id = json['id'];
    return user;
  }  



}