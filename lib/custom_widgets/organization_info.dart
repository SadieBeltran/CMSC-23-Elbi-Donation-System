import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:flutter/material.dart';

class OrganizationInfo extends StatelessWidget {
  final Organization org;
  const OrganizationInfo({required this.org, super.key});

  @override
  Widget build(BuildContext context) {
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
          Image.network(
            org.proofOfLegitimacy,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          _orgName,
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
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(org.contactNumber),
          ),
          _orgdescription
          //phoneNumber
        ],
      ),
    );
  }

  Widget get _orgName => FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        //ORGANIZATION NAME
        org.organizationName,
        textAlign: TextAlign.start,
        softWrap: true,
        overflow:
            TextOverflow.ellipsis, // for handling overflow for very long texts
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ));

  Widget get _orgdescription => Wrap(
        children: [
          org.description == null ? const Text("") : Text(org.description!)
        ],
      );
}
