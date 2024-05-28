import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/donationDrive_card.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:flutter/material.dart';

class DonationDriveListView extends StatelessWidget {
  final Organization org;
  const DonationDriveListView({required this.org, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: org.donationDrives!.length,
          itemBuilder: (context, index) {
            return SizedBox(
              width: 300,
              child:
                  DonationDriveListViewItem(drive: org.donationDrives![index]),
            );
          }),
    );
    ;
  }
}
