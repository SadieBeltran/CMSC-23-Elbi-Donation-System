import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/firebase_donation_drive_api.dart';
import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:flutter/material.dart';

class DonationDriveProvider with ChangeNotifier {
  FirebaseDonationDriveAPI firebaseService = FirebaseDonationDriveAPI();
  late Stream<QuerySnapshot> _donationDrives;

  DonationDriveProvider() {
    fetchDrives();
  }

  void fetchDrives() {
    _donationDrives = firebaseService.getAllDrives();
    notifyListeners();
  }

  Future<List<DonationDrive>> getOrgDrives(String id) async {
    // https://stackoverflow.com/questions/65754873/flutter-firebase-get-stream-of-list-of-document-snapshots-from-list-of-document ??????????
    List<DonationDrive> driveList = [];
    List<DocumentReference<Object?>>? s =
        await firebaseService.getOrgDrives(id);
    if (s != null) {
      for (DocumentReference ref in s) {
        ref.get().then((value) {
          if (value.exists) {
            driveList.add(
                DonationDrive.fromJson(value.data() as Map<String, dynamic>));
          }
        });
      }
    }
    return driveList;
  }

  Future<void> addDrive(DonationDrive drive, String id) async {
    String message = await firebaseService.addDrive(drive.toJson(drive), id);
    print(message);
    notifyListeners();
  }
}
