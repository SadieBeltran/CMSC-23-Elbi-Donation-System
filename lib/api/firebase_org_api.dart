import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseOrgAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addOrg(Map<String, dynamic> org) async {
    try {
      await db.collection("organizations").add(org);

      return "Successfully added!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllOrgs() {
    print("getting orgs");
    return db.collection("organizations").snapshots();
  }

//   Future<List<String>> getAllUsernames() async {
//     try {
//       QuerySnapshot querySnapshot = await db.collection("donors").get();
//       List<String> usernames =
//           querySnapshot.docs.map((doc) => doc['username'] as String).toList();
//       return usernames;
//     } on FirebaseException catch (e) {
//       print("Error in ${e.code}: ${e.message}");
//       return [];
//     }
//   }

//   Future<bool> usernameExists(String? username) async {
//     try {
//       QuerySnapshot querySnapshot = await db
//           .collection("donors")
//           .where('username', isEqualTo: username)
//           .get();
//       return true;
//     } on FirebaseException catch (e) {
//       print("Error in ${e.code}: ${e.message}");
//       return false;
//     }
//   }
}

// Stream<QuerySnapshot> getAllTodos() {
  //   return db.collection("todos").snapshots();
  // }

  // Future<String> deleteTodo(String id) async {
  //   try {
  //     await db.collection("todos").doc(id).delete();

  //     return "Successfully deleted!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> editTodo(String id, String title) async {
  //   try {
  //     await db.collection("todos").doc(id).update({"title": title});

  //     return "Successfully edited!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> toggleStatus(String id, bool value) async {
  //   try {
  //     await db.collection("todos").doc(id).update({"completed": value});

  //     return "Successfully toggled!";
  //   } on FirebaseException catch (e) {
  //     return "Error in ${e.code}: ${e.message}";
  //   }
  // }