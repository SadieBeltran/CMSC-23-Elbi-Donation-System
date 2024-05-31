import 'dart:convert';

import 'donor.dart';

// model for donation-drives in elbi-donation system, based on model in sheets.
class DonationDrive {
  String? driveId;
  String description;
  String driveName;
  DateTime startDate;
  DateTime endDate;
  int status;
  // List<Donation> donations;
  List<Donor>? donors;
  DonationDrive({
    this.driveId,
    required this.description,
    required this.driveName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.donors,
  });

  // Factory constructor to instantiate object from json format
  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
        description: json['description'],
        driveName: json['driveName'],
        startDate: DateTime.fromMicrosecondsSinceEpoch(json['startDate']),
        endDate: DateTime.fromMicrosecondsSinceEpoch(json['endDate']),
        status: json['status']);
  }

  static List<DonationDrive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<DonationDrive>((dynamic d) => DonationDrive.fromJson(d))
        .toList();
  }

  //Will be used to add to db by firebase_Users_api.dart
  Map<String, dynamic> toJson(DonationDrive drive) {
    return {
      'driveName': drive.driveName,
      'description': drive.description,
      'startDate': drive.startDate,
      'endDate': drive.endDate,
      'status': drive.status,
    };
  }
}
