import 'dart:convert';

import 'package:uuid/uuid.dart';

// utility object that generates unique id
const uuid = Uuid();

class Donor {
  // constructor
  Donor({
    this.id,
    // required this.name,
    required this.firstName,
    required this.lastName,
    required this.username,
    // required this.password,
    // required this.addresses,
    required this.contactNumber,
  }) {
    // if the value of id is null, then the app will auto fill the id field
    id = id ?? uuid.v4();
  }

  // properties
  String? id;

  // properties
  // final Map<String, String> name;
  final String firstName;
  final String lastName;
  final String username;
  // final String password;
  // final List<String> addresses;
  final String contactNumber;

  // Factory constructor to instantiate object from json format
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        username: json['username'],
        // addresses: json['addresses'],
        contactNumber: json['contactNumer']);
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
      'username': donor.username,
      // 'addresses': donor.addresses,
      'contactNumber': contactNumber
    };
  }
}
