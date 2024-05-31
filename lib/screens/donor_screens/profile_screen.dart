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
  String currentUserId = "";
  String? userType = "";
  Organization? org = null;
  Donor? donor = null;

  @override
  void initState() async {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    userType =
        await context.read<UserAuthProvider>().getUserType(currentUserId);
    if (userType == "org") {
      mounted
          ? org = context.read<OrgListProvider>().getCurrentOrg(currentUserId)
          : null;
    } else if (userType == "donor") {
      mounted
          ? donor =
              context.read<DonorListProvider>().getCurrentDonor(currentUserId)
          : null;
    } else if (userType == null || userType == "admin") {
      print("how the fuck did you get here");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
            child: userType == "org"
                ? OrganizationInfo(org: org!)
                : DonorInfo(donor: donor!)));
  }
}
