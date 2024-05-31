import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/providers/donation_drive_provider.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:elbi_donation_system/screens/donor_screens/profile_screen.dart';
import 'package:elbi_donation_system/screens/organization_screens/create_donation_drive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      const Text("Donation Page"),
      _donationDriveListBuilder(),
      const ProfileScreen()
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome, organization!'),
          actions: [
            IconButton(
                onPressed: () {
                  // logout
                  context.read<UserAuthProvider>().signOut();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Center(child: widgetList[myIndex]),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.groups_2_outlined), label: 'Donations'),
            BottomNavigationBarItem(
                icon: Icon(Icons.approval_outlined), label: 'Donation Drives'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: 'Profile')
          ],
        ));
  }

  Widget _donationDriveListBuilder() {
    return FutureBuilder(
        future: context
            .read<DonationDriveProvider>()
            .getOrgDrives(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, AsyncSnapshot<List<DonationDrive>> snapshot) {
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
          } else {
            List<DonationDrive> drive = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: drive.length,
                    itemBuilder: (context, index) {
                      return _donationDriveItem(drive[index]);
                    },
                  ),
                  TextButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (con) {
                            String currentUserId =
                                FirebaseAuth.instance.currentUser!.uid;

                            return CreateDonationDrivePage(
                                orgId: currentUserId);
                          }),
                        );
                      },
                      label: const Text("Add Donation Drive"))
                ],
              ),
            );
          }
        });
  }

  Widget _donationDriveItem(DonationDrive drive) {
    return ListTile(
      title: Text(drive.driveName),
      trailing: IconButton(
        onPressed: () {
          // delete this specific drive
          print("Deleting ${drive.driveId}");
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}
