import 'dart:convert';
import 'donor.dart';

// model for donation-drives in elbi-donation system, based on model in sheets.
class DonationDrive {
  String? driveId;
  String driveName;
  DateTime startDate;
  DateTime endDate;
  int status;
  // List<Donation> donations;
  List<Donor>? donors;
  DonationDrive({
    this.driveId,
    required this.driveName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.donors,
  });
}
