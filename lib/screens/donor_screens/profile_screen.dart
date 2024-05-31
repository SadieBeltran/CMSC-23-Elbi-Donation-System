import 'package:elbi_donation_system/screens/donor_screens/donor_info.dart';
import 'package:elbi_donation_system/custom_widgets/organization_info.dart';
import 'package:elbi_donation_system/data_models/donor.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/providers/donor_provider.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// get currently logged in based on
// TEMPORARY

class _ProfileScreenState extends State<ProfileScreen> {
  // var currentlyLoggedIn = dummyOrganizations[0];
  //GET CUYRRENT USER
  //determine if user is org or not
  //if org, display orgcontents,
  //if user, display profile
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String userType = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: context.read<UserAuthProvider>().getUserType(currentUserId),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Todos Found"),
            );
          }
          // BUG: Null check operator used on a null value

          userType = snapshot.data!;
          print("profile Screen: $userType");
          if (userType == "admin" || userType == "null") {
            Navigator.pop(context);
          } else if (userType == "org") {
            return OrganizationInfo(id: currentUserId);
          } else if (userType == "donor") {
            return DonorInfo(id: currentUserId);
          }
          return Container();
        });
  }
}
