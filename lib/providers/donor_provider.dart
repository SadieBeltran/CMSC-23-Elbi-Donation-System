import 'package:flutter/material.dart';
import '../api/firebase_donor_api.dart';
import '../data_models/donor.dart';

class DonorListProvider with ChangeNotifier {
  FirebaseDonorAPI firebaseService = FirebaseDonorAPI();
  // late Stream<QuerySnapshot> _todosStream;

  DonorListProvider() {
    // fetchTodos();
  }
  // getter
  // Stream<QuerySnapshot> get todo => _todosStream;

  // void fetchTodos() {
  //   _todosStream = firebaseService.getAllTodos();
  //   notifyListeners();
  // }

  Future<void> addDonor(Donor donor) async {
    String message = await firebaseService.addDonor(donor.toJson(donor));
    print(message);
    print("ADDED");
    notifyListeners();
  }

  Future<bool> usernameExists(String username) async {
    return await firebaseService.usernameExists(username);
  }

  // void editTodo(String id, String newTitle) async {
  //   await firebaseService.editTodo(id, newTitle);
  //   notifyListeners();
  // }

  // void deleteTodo(String id) async {
  //   await firebaseService.deleteTodo(id);
  //   notifyListeners();
  // }

  // void toggleStatus(String id, bool status) async {
  //   await firebaseService.toggleStatus(id, status);
  //   notifyListeners();
  // }
}
