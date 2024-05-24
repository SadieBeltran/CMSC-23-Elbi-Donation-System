import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'app_user.dart';

// utility object that generates unique id
const uuid = Uuid();

class Donor extends AppUser {
  // properties
  String? uid;
  // constructor
  Donor({
    this.uid,
    // required this.name,
    required super.firstName,
    required super.lastName,
    required super.userName,
    super.userType,
    // required this.password,
    // required this.addresses,
    required super.contactNumber,
    required super.email,
  }) {
    // if the value of id is null, then the app will auto fill the id field
    uid = uid ?? uuid.v4();
    super.userType = 0;
  }

  // // properties
  // // final Map<String, String> name;
  // final String firstName;
  // final String lastName;
  // final String username;
  // // final String password;
  // // final List<String> addresses;
  // final String contactNumber;

  // Factory constructor to instantiate object from json format
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
        uid: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        userName: json['username'],
        userType: json['userType'],
        // addresses: json['addresses'],
        contactNumber: json['contactNumer'],
        email: json['email']);
  }

  static List<Donor> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donor>((dynamic d) => Donor.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donor donor) {
    return {
      'id': donor.id,
      'firstName': donor.firstName,
      'lastName': donor.lastName,
      'username': donor.userName,
      // 'addresses': donor.addresses,
      'contactNumber': contactNumber
    };
  }
}
