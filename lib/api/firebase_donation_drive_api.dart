import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDrive(Map<String, dynamic> drive, String orgId) async {
    try {
      drive['startDate'] = Timestamp.fromDate(drive['startDate']);
      drive['endDate'] = Timestamp.fromDate(drive['endDate']);
      DocumentReference doc = await db.collection("donation-drives").add(drive);

      // https://firebase.google.com/docs/firestore/manage-data/add-data#dart_12
      // adds donationDrive id to donationDrives field in organization db
      await db.collection("organization").doc(orgId).update({
        "donationDrives": FieldValue.arrayUnion([doc.id])
      });

      return "Successfully added item!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllDrives() {
    print("getting donation items");
    return db.collection("donation-drives").snapshots();
  }
}
