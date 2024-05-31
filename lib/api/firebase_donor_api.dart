import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonorAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonor(Map<String, dynamic> donor, String? id) async {
    try {
      await db.collection("donors").doc(id).set(donor);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonors() {
    return db.collection("donors").snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDonor(String? id) {
    return db.collection("donors").doc(id).get();
  }
}
