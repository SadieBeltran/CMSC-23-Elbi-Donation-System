import 'package:elbi_donation_system/custom_widgets/donor_views/donationDrive_list_view.dart';
import 'package:elbi_donation_system/custom_widgets/organization_info.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/screens/organization_screens/create_donation_drive.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

// get currently logged in based on
// TEMPORARY

class _ProfileScreenState extends State<ProfileScreen> {
  // var currentlyLoggedIn = dummyOrganizations[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
            // child: orgInfo(currentlyLoggedIn),
            ));
  }

  Widget orgInfo(Organization org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero(
        //   tag: org.id!,
        //   child: Image.asset(
        //     org.orgImagePath,
        //     height: 250,
        //     width: double.infinity,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrganizationInfo(org: org),
              Row(children: [
                org.donationDrives == null
                    ? Container()
                    : DonationDriveListView(org: org),
                TextButton.icon(
                  icon: const Icon(Icons.add),
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // MUST PASS ORG OBJ
                    // MUST BE AN ORGANIZATION TOO
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    CreateDonationDrivePage(org: org)))
                        .then((value) => setState(() {}));
                  },
                  label: const Text("Create New Donation Drive"),
                )
              ]) // links ng donation drive
            ],
          ),
        )
      ],
    );
  }
}
