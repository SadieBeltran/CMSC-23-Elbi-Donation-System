import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// data model
import 'package:elbi_donation_system/data_models/organization.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({
    required this.org,
    super.key,
  });

  // property
  final Organization org;

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
              tag: org.id!,
              child: Image.asset(
                org.orgImagePath,
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
                  organizationInfo(org),
                  // Donation Input Fields
                  const Divider(
                    thickness: 4,
                    color: Colors.grey,
                  ),
                  donationForm()
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

  Widget donationDrives(Organization org) {
    //Listview.builder of org's donation drives, make them clickable buttons.
    return Container();
  }

//form should be moved to donationdrive...
  Widget donationForm() {
    List<String> donationTypes = [];
    //will need to upload to cloudFirestore
    return const Form(
      child: Column(
        children: [
          //Title
          Text(
            "Donate Here",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Column(
            children: [
              //Checkbox list of item type for donationType. Must not be empty
              //is pickUp on-off switch
              //weight
              //time is automatically recorded
              //Choose Donation Drive
              //Button to save
            ],
          )
        ],
      ),
    );
  }
}
