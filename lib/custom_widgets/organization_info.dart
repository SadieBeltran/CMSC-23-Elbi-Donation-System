import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:elbi_donation_system/screens/organization_screens/edit_org_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationInfo extends StatelessWidget {
  final String id;
  const OrganizationInfo({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<OrgListProvider>().getCurrentOrg(id),
        builder: (context, AsyncSnapshot snapshot) {
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
          }
          Organization org = snapshot.data;

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
                Row(
                  children: [
                    _orgName(org.organizationName),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => EditProfilePage(user: org),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit))
                  ],
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
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(org.contactNumber),
                ),
                _orgdescription(org.description)
                //phoneNumber
              ],
            ),
          );
        });
  }

  Widget _orgName(String orgName) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          //ORGANIZATION NAME
          orgName,
          textAlign: TextAlign.start,
          softWrap: true,
          overflow: TextOverflow
              .ellipsis, // for handling overflow for very long texts
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ));
  }

  Widget _orgdescription(String? description) {
    return Wrap(
      children: [description == null ? const Text("") : Text(description)],
    );
  }
}
