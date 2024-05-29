import 'dart:convert';
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
  List<dynamic>? donationDrives;
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
