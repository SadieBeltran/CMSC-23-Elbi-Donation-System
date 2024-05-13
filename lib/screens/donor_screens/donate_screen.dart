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
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.organizationName,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          overflow: TextOverflow
                              .ellipsis, // for handling overflow for very long texts
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Donation Input Fields
                  const Form(
                    child: Column(
                      children: [],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
