import 'package:elbi_donation_system/custom_widgets/donor_views/donationDrive_list_view.dart';
import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/donationDrive_card.dart';
import 'package:elbi_donation_system/data/dummy_organizations.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/screens/organization_screens/create_donation_drive.dart';
import 'package:elbi_donation_system/screens/organization_screens/edit_profile.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/foundation.dart';
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
              orgContent(org),
              Row(children: [
                DonationDriveListView(org: org),
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

  Widget orgContent(Organization org) {
    return Container(
      margin: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: const BoxDecoration(
        // color: Colors.black45,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _orgName,
            Wrap(
              children: [Text(org.description!)],
            ),
            //Addresses (Make this a ListView.builder, to be changed into Streambuilder later)
            const Text(
              "Addresses",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            ListView.builder(
              //ADDRESS
              shrinkWrap: true,
              itemCount: org.addresses.length,
              itemBuilder: ((context, index) {
                return ListTile(
                    title: Text(org.addresses[index]),
                    leading: const Icon(Icons.location_city_outlined));
              }),
            ),
            //username
            // ListTile(
            //   leading: const Icon(Icons.person),
            //   title: Text(org.username),
            // ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(org.contactNumber),
            )
          ]),
    );
  }

  Widget get _orgName => Row(children: [
        // Expanded(
        //     flex: 1,
        //     child: Text(
        //       //ORGANIZATION NAME
        //       currentlyLoggedIn.organizationName,
        //       textAlign: TextAlign.start,
        //       softWrap: true,
        //       overflow: TextOverflow
        //           .ellipsis, // for handling overflow for very long texts
        //       style: const TextStyle(
        //         fontSize: 40,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.black,
        //       ),
        //     )),
        // Expanded(
        //     flex: 1,
        //     child: IconButton(
        //       icon: const Icon(Icons.edit),
        //       onPressed: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (ctx) => EditProfilePage(user: currentlyLoggedIn),
        //           ),
        //         );
        //       },
        //     ))
      ]);
}
