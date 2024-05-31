import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/api/firebase_appUser_api.dart';
import 'package:elbi_donation_system/data_models/app_user.dart';
import 'package:flutter/material.dart';

class AppUserProvider with ChangeNotifier {
  FirebaseAppUserAPI firebaseService = FirebaseAppUserAPI();

  AppUserProvider();

// handles adding the user in db
  Future<void> addAppUser(AppUser appUser) async {
    String message =
        await firebaseService.addAppUser(appUser.toJson(appUser), appUser.id);
    print(message);
    notifyListeners();
  }

// https://stackoverflow.com/questions/72565370/querying-for-document-id-with-firestore
  AppUser getCurrentUser(String? id) {
    //https://stackoverflow.com/questions/70479637/flutter-firestore-documentsnapshot-to-map
    return AppUser.fromJson(
        firebaseService.getAppUser(id) as Map<String, dynamic>);
  }
}
