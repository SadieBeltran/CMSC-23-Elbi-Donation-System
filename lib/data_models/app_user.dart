// this is the model for user.
// import 'donation_item.dart';
// import 'donation_drive.dart';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String? id;
  int userType;
  AppUser({this.id, required this.userType});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userType: json['userType'],
    );
  }

  static List<AppUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AppUser>((dynamic d) => AppUser.fromJson(d)).toList();
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AppUser(userType: data['userType']);
  }

//Will be used to add to db by firebase_Users_api.dart
  Map<String, dynamic> toJson(AppUser appUser) {
    return {'userType': appUser.userType};
  }
}
