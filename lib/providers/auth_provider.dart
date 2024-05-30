import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _uStream;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => _uStream;
  User? get user => authService.getUser();
  String? get uid => authService.getUserUID();

  void fetchAuthentication() {
    _uStream = authService.userSignedIn();

    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    await authService.signUp(email, password);
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    String? message = await authService.signIn(email, password);
    notifyListeners();

    return message;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

  Future<bool> signInAndNavigate(
      BuildContext context, String email, String password) async {
    String? message = await authService.signIn(email, password);
    print("message: ${message}");
    if (message == "success") {
      String? userType = await getUserType(authService.getUserUID()!);
      print("userType: ${userType}");
      if (userType != null) {
        print("NAVIGATING");
        navigateToHomePage(context, userType);
        return true;
      } else {
        return false; // User type not found
      }
    } else {
      return false; // Sign-in failed
    }
  }

  Future<String?> getUserType(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print(uid);
    // Check Admin collection
    DocumentSnapshot adminSnapshot =
        await firestore.collection('admins').doc(uid).get();
    if (adminSnapshot != null) {
      print("admin");
      return 'admin';
    }

    // Check Donor collection
    DocumentSnapshot donorSnapshot =
        await firestore.collection('donors').doc(uid).get();
    if (donorSnapshot != null) {
      print("donor");
      return 'donor';
    }

    // Check Org collection
    DocumentSnapshot orgSnapshot =
        await firestore.collection('organizations').doc(uid).get();
    if (orgSnapshot != null) {
      print("org");
      return 'org';
    }

    return null; // If user type is not found
  }

  void navigateToHomePage(BuildContext context, String userType) {
    // Implement navigation based on user type
    print("userType: ${userType}");
    switch (userType) {
      case 'admin':
        Navigator.pushNamed(context, '/adminHome');
        break;
      case 'donor':
        Navigator.pushNamed(context, '/donorHome');
        break;
      case 'org':
        Navigator.pushNamed(context, '/orgHome');
        break;
      default:
        // Handle unknown user type
        print("UNKNOWN");
        break;
    }
  }
}
