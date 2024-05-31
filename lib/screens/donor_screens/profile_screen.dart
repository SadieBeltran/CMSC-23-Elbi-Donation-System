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
    return FutureBuilder(
        future: Future.wait([
          context.read<UserAuthProvider>().getUserType(currentUserId),
          context.read<OrgListProvider>().getCurrentOrg(currentUserId),
          context.read<DonorListProvider>().getCurrentDonor(currentUserId)
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          userType = snapshot.data![0];
          Organization org =
              Organization.fromJson(snapshot.data![1] as Map<String, dynamic>);
          Donor donor =
              Donor.fromJson(snapshot.data![2] as Map<String, dynamic>);
          if (userType == "admin" || userType == "null") {
            Navigator.pop(context);
          }
// BUG: Null check operator used on a null value
          return Scaffold(
              appBar: AppBar(
                title: const Text("Profile"),
              ),
              drawer: const DrawerWidget(),
              body: SingleChildScrollView(
                  child: userType == "org"
                      ? OrganizationInfo(org: org)
                      : DonorInfo(donor: donor)));
        });
  }
}
