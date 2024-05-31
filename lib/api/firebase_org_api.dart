import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrgAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addOrg(Map<String, dynamic> org, String? id) async {
    try {
      await db.collection("organizations").doc(id).set(org);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getApprovedOrgs() {
    return db
        .collection("organizations")
        .where(Filter("accepted", isEqualTo: true))
        .snapshots();
  }

  Stream<QuerySnapshot> getUnapprovedOrgs() {
    return db
        .collection("organizations")
        .where(Filter("accepted", isEqualTo: false))
        .snapshots();
  }

  Stream<QuerySnapshot> getAllOrgs() {
    print("getting orgs");
    return db.collection("organizations").snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrg(String? id) {
    return db.collection("organizations").doc(id).get();
  }
}
