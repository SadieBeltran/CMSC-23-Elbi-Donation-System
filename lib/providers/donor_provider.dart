import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donor_api.dart';
import '../data_models/donor.dart';

class DonorListProvider with ChangeNotifier {
  FirebaseDonorAPI firebaseService = FirebaseDonorAPI();
  late Stream<QuerySnapshot> _donorsStream;

  DonorListProvider() {
    fetchAllDonors();
  }
  // getter
  Stream<QuerySnapshot> get donor => _donorsStream;

  void fetchAllDonors() {
    _donorsStream = firebaseService.getAllDonors();
    notifyListeners();
  }

  Future<void> addDonor(Donor donor) async {
    String message =
        await firebaseService.addDonor(donor.toJson(donor), donor.uid);
    print(message);
    print("ADDED");
    notifyListeners();
  }

  Future<Donor> getCurrentDonor(String id) async {
    // BUG: see getCurrentOrg for note
    DocumentSnapshot<Map<String, dynamic>> snap =
        await firebaseService.getDonor(id);
    if (snap.exists) {
      return Donor.fromJson(snap.data() as Map<String, dynamic>);
    } else {
      throw ("From getCurrentDonor: ID does not exist");
    }
  }
}
