import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAppUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addAppUser(Map<String, dynamic> appUser, String? id) async {
    try {
      await db.collection("app-user").doc(id).set(appUser);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    print("getting appusers");
    return db.collection("app-user").snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getAppUser(String? id) {
    return db.collection("app-users").doc(id).get();
  }
}
