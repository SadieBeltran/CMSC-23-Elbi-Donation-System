import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/data_models/donation_item.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
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
            // Org Details
            // org image
            Hero(
              tag: widget.org.id!,
              child: Image.asset(
                widget.org.orgImagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // container for adding margin
            Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // more details about the org
                  // container for the black background
                  organizationInfo(widget.org),
                  // Donation Input Fields
                  const Divider(
                    thickness: 4,
                    color: Colors.grey,
                  ),
                  DonationDriveListView(org: widget.org)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget organizationInfo(Organization org) {
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
          Text(
            //ORGANIZATION NAME
            org.organizationName,
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow
                .ellipsis, // for handling overflow for very long texts
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
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
            shrinkWrap: true,
            itemCount: org.addresses.length,
            itemBuilder: ((context, index) {
              return ListTile(
                  title: Text(org.addresses[index]),
                  leading: const Icon(Icons.location_city_outlined));
            }),
          ),
          //username
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(org.username),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(org.contactNumber),
          )
          //phoneNumber
        ],
      ),
    );
  }
}
