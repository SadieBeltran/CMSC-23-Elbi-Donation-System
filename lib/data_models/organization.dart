import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// utility object that generates unique id
const uuid = Uuid();

class Organization {
  // properties
  String? uid;
  final String organizationName;
  final List<dynamic> addresses;
  final String contactNumber;
  final String proofOfLegitimacy;
  final bool accepted;
  String? description;
  List<DocumentReference>? donationDrives;
  // constructor
  Organization(
      {this.uid,
      required this.organizationName,
      required this.addresses,
      required this.contactNumber,
      required this.proofOfLegitimacy,
      required this.accepted,
      this.description,
      this.donationDrives});
// make sure to get names right
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      uid: json['uid'],
      accepted: json['accepted'],
      addresses: json['addresses'],
      contactNumber: json['contactNumber'],
      description: json['description'],
      donationDrives: json['donationDrives'],
      organizationName: json['organizationName'],
      proofOfLegitimacy: json['proofOfLegitimacy'],
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<Organization>((dynamic d) => Organization.fromJson(d))
        .toList();
  }

  Map<String, dynamic> toJson(Organization organization) {
    return {
      'uid': organization.uid,
      'organizationName': organization.organizationName,
      'addresses': organization.addresses,
      'contactNumber': organization.contactNumber,
      'proofOfLegitimacy': organization.proofOfLegitimacy,
      'accepted': organization.accepted,
      'description': organization.description,
      'donationDrives': organization.donationDrives
    };
  }
}
