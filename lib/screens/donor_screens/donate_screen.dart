// import 'dart:js_util';

import 'package:elbi_donation_system/custom_widgets/donor_views/donationDrive_list_view.dart';
import 'package:elbi_donation_system/custom_widgets/organization_info.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// data model
import 'package:elbi_donation_system/data_models/organization.dart';

class DonateScreen extends StatefulWidget {
  final Organization org;
  const DonateScreen({required this.org, super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // more details about the org
                  // container for the black background
                  OrganizationInfo(org: widget.org),
                  // Donation Input Fields
                  const Divider(
                    thickness: 4,
                    color: Colors.grey,
                  ),
                  widget.org.donationDrives == null
                      ? Container()
                      : DonationDriveListView(org: widget.org),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
