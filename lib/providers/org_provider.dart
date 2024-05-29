import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_org_api.dart';
import '../data_models/organization.dart';

class OrgListProvider with ChangeNotifier {
  FirebaseOrgAPI firebaseService = FirebaseOrgAPI();
  late Stream<QuerySnapshot> _orgStream;

  OrgListProvider() {
    fetchOrgs();
  }

  Stream<QuerySnapshot> get orgs => _orgStream;

  void fetchOrgs() {
    _orgStream = firebaseService.getAllOrgs();
    print("successfully fetched orgs");
    notifyListeners();
  }

  Future<void> addOrg(Organization organization) async {
    String message =
        await firebaseService.addOrg(organization.toJson(organization));
    print(message);
    print("ADDED");
    notifyListeners();
  }
}
