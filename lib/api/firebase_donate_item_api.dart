import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonateItemAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donationItem) async {
    try {
      await db.collection("donation-item").add(donationItem);

      return "Successfully added item!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDonations() {
    print("getting donation items");
    return db.collection("donation-item").snapshots();
  }
}
