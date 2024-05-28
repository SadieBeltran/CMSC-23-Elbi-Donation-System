import 'package:flutter/material.dart';
import '../api/firebase_org_api.dart';
import '../data_models/organization.dart';

class OrgListProvider with ChangeNotifier {
  FirebaseOrgAPI firebaseService = FirebaseOrgAPI();
  // late Stream<QuerySnapshot> _todosStream;

  OrgListProvider() {
    // fetchTodos();
  }
  // getter
  // Stream<QuerySnapshot> get todo => _todosStream;

  // void fetchTodos() {
  //   _todosStream = firebaseService.getAllTodos();
  //   notifyListeners();
  // }

  Future<void> addOrg(Organization organization) async {
    String message =
        await firebaseService.addOrg(organization.toJson(organization));
    print(message);
    print("ADDED");
    notifyListeners();
  }
}
