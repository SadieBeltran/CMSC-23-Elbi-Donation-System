import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_org_api.dart';
import '../data_models/organization.dart';

class OrgListProvider with ChangeNotifier {
  FirebaseOrgAPI firebaseService = FirebaseOrgAPI();
  // late Stream<QuerySnapshot> _orgStream;
  late Stream<QuerySnapshot> _approvedOrgStream;
  late Stream<QuerySnapshot> _unapprovedOrgStream;

   OrgListProvider() {
    fetchApprovedOrgs();
    fetchUnapprovedOrgs();
  }

  Stream<QuerySnapshot> get approvedOrgs => _approvedOrgStream;
  Stream<QuerySnapshot> get unapproved => _unapprovedOrgStream;

  void fetchApprovedOrgs() {
    _approvedOrgStream = firebaseService.getApprovedOrgs();
    print("Fetching approved orgs");
    notifyListeners();
  }

  void fetchUnapprovedOrgs() {
    _unapprovedOrgStream = firebaseService.getUnapprovedOrgs();
    print("Fetching unapproved orgs");
    notifyListeners();
  }

  // void fetchOrgs() {
  //   _orgStream = firebaseService.getAllOrgs();
  //   print("successfully fetched orgs");
  //   notifyListeners();
  // }

  Future<void> addOrg(Organization organization) async {
    String message = await firebaseService.addOrg(
        organization.toJson(organization), organization.uid);
    print(message);
    print("ADDED");
    notifyListeners();
  }
}
