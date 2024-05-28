import 'dart:convert';

import 'package:uuid/uuid.dart';

// utility object that generates unique id
const uuid = Uuid();

class Donor {
  //PROPERTIES
  String? uid;
  String firstName;
  String lastName;
  String userName;
  List<String> addresses;
  String contactNumber;
  // constructor
  Donor({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.userName,
    // required this.password,
    required this.addresses,
    required this.contactNumber,
  });
  // Factory constructor to instantiate object from json format
  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      uid: json['uid'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['username'],
      addresses: json['addresses'],
      contactNumber: json['contactNumer'],
    );
  }

  static List<Donor> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donor>((dynamic d) => Donor.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donor donor) {
    return {
      'uid': donor.uid,
      'firstName': donor.firstName,
      'lastName': donor.lastName,
      'username': donor.userName,
      'addresses': donor.addresses,
      'contactNumber': contactNumber
    };
  }
}
