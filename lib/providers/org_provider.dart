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

  Future<void> acceptOrganization(String id) async {
    await firebaseService.updateOrganizationStatus(id, true);
    notifyListeners();
  }

  Future<void> declineOrganization(String id) async {
    await firebaseService.updateOrganizationStatus(id, false);
    notifyListeners();
  }

  // void fetchOrgs() {
  //   _orgStream = firebaseService.getAllOrgs();
  //   print("successfully fetched orgs");
  //   notifyListeners();
  // }

  Future<Organization> getCurrentOrg(String id) async {
    // BUG: Unhandled Exception: type 'Future<DocumentSnapshot<Map<String, dynamic>>>' is not a subtype of type 'Map<String, dynamic>' in type cast
    DocumentSnapshot<Map<String, dynamic>> snap =
        await firebaseService.getOrg(id);
    if (snap.exists) {
      return Organization.fromJson(snap.data() as Map<String, dynamic>);
    }
    throw ("From getCurrentOrg: ID does not exist!");
  }

  Future<void> addOrg(Organization organization) async {
    String message = await firebaseService.addOrg(
        organization.toJson(organization), organization.uid);
    print(message);
    print("ADDED");
    notifyListeners();
  }
}
