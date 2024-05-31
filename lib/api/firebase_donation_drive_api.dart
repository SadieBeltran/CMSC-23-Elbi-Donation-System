import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/data_models/organization.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDrive(Map<String, dynamic> drive, String orgId) async {
    try {
      drive['startDate'] = Timestamp.fromDate(drive['startDate']);
      drive['endDate'] = Timestamp.fromDate(drive['endDate']);
      DocumentReference ref = await db.collection("donation-drives").add(drive);

      // https://firebase.google.com/docs/firestore/manage-data/add-data#dart_12
      // adds donationDrive id to donationDrives field in organization db
      print("REF.id ${ref.id} Org.id ${orgId}");
      await db.collection("organizations").doc(orgId).update({
        "donationDrives": FieldValue.arrayUnion([ref.id])
      });

      return "Successfully added item!";
    } on FirebaseException catch (e) {
      print("DonationDrive FirebaseException");
      return "Error in ${e.code}: ${e.message}";
    }
  }

// https://stackoverflow.com/questions/64327490/flutter-firebase-retrieve-a-list-of-documents-limited-to-ids-in-an-array
  Future<List<DocumentReference<Object?>>?> getOrgDrives(String id) async {
    List<DocumentReference>? refs;
    await db.collection("organizations").doc(id).get().then(
      (value) {
        if (value.exists) {
          var e = Organization.fromJson(value.data() as Map<String, dynamic>);
          if (e.donationDrives != null) {
            refs = [for (var x in e.donationDrives!) x as DocumentReference];
          }
        }
      },
    );
    if (refs != null) {
      // query.
      return refs;
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot> getAllDrives() {
    print("getting donation items");
    return db.collection("donation-drives").snapshots();
  }
}
