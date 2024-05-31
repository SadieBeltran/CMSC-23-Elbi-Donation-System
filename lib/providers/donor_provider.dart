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

  Donor getCurrentDonor(String id) {
    return Donor.fromJson(firebaseService.getDonor(id) as Map<String, dynamic>);
  }
}
