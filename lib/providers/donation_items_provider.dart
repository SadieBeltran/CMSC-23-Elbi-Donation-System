import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/firebase_donate_item_api.dart';
import 'package:elbi_donation_system/data_models/donation_item.dart';
import 'package:flutter/material.dart';

class DonationItemProvider with ChangeNotifier {
  FirebaseDonateItemAPI firebaseService = FirebaseDonateItemAPI();
  late Stream<QuerySnapshot> _donationItems;

  DonationItemProvider() {
    fetchDonationItems();
  }

  Stream<QuerySnapshot> get donationItems => _donationItems;

  void fetchDonationItems() {
    _donationItems = firebaseService.getAllDonations();
    notifyListeners();
  }

  Future<void> addDonation(DonationItem item) async {
    String message = await firebaseService.addDonation(item.toJson(item));
    print(message);
    notifyListeners();
  }
}
