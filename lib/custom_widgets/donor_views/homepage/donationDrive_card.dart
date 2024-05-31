import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/screens/donor_screens/donation_drive.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonationDriveListViewItem extends StatelessWidget {
  final DocumentReference drive;
  const DonationDriveListViewItem({required this.drive, super.key});

  @override
  Widget build(BuildContext context) {
    // convert the document reference into an object
    DonationDrive donation =
        DonationDrive.fromJson(drive as Map<String, dynamic>);
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          // go to donation drive screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => DonationDrivePage(drive: donation),
            ),
          );
        },
        splashColor: Colors.black,
        // pretend this has a photo
        child: Stack(
          children: [
            Image.asset(
              'assets/images/org_images/kulto.png',
              fit: BoxFit.cover,
              width: 300,
              height: 100,
            ), //need to implement image in drive model
            // Positioned widget positions a widget on top of another widget in the stack
            Positioned(
              // make the child widget container be positioned in the bottom of the
              // previous widget in the stack, and span left to right
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(height: ),
                    name(donation.driveName),
                    duration(donation.startDate, donation.endDate),
                    ListTile(
                      leading: const Text("Status: "),
                      title: status(donation.status),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatus(int code) {
    switch (code) {
      case 0:
        return "Setting Up";
      case 1:
        return "Ongoing";
      case 2:
        return "Finished";
    }
    return "";
  }

  Widget status(int driveStatus) {
    return ListTile(
        leading: const Text("Status:"),
        title: Text(
          getStatus(driveStatus),
        ));
  }

  Widget name(String name) {
    return Text(
      name,
      textAlign: TextAlign.start,
      softWrap: true,
      overflow:
          TextOverflow.ellipsis, // for handling overflow for very long texts
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget duration(DateTime startDate, DateTime endDate) {
    return Row(
      children: [
        Expanded(
            child: ListTile(
                leading: const Text("Start"),
                title: Text(DateFormat('yyyy-MM-dd').format(startDate)))),
        Expanded(
            child: ListTile(
                leading: const Text("End:"),
                title: Text(DateFormat('yyyy-MM-dd').format(endDate))))
      ],
    );
  }
}
