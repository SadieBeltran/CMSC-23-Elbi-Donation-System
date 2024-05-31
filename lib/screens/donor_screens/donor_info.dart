import 'package:elbi_donation_system/data_models/donor.dart';
import 'package:elbi_donation_system/providers/donor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorInfo extends StatelessWidget {
  final String id;
  const DonorInfo({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<DonorListProvider>().getCurrentDonor(id),
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

          Donor donor = snapshot.data;

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
                  donor.profilePicture != null
                      ? Image.network(
                          donor.profilePicture!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                  _donorUsername(donor.userName),
                  _addresses(donor.addresses),
                  _legalName(donor.firstName, donor.lastName),
                  _contactNumber(donor.contactNumber),
                ]),
          );
        });
  }

  Widget _addresses(List<String>? addresses) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: addresses == null ? 0 : addresses.length,
      itemBuilder: ((context, index) {
        return ListTile(
            title: Text(addresses![index]),
            leading: const Icon(Icons.location_city_outlined));
      }),
    );
  }

  Widget _contactNumber(String contactNumber) {
    return ListTile(
        leading: const Icon(Icons.phone), title: Text(contactNumber));
  }

  Widget _legalName(String firstName, String lastName) => ListTile(
        leading: const Text("Name"),
        title: Text("$firstName $lastName"),
      );

  Widget _donorUsername(String userName) => Row(
        children: [
          Expanded(
            flex: 1,
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  //ORGANIZATION NAME
                  userName,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  overflow: TextOverflow
                      .ellipsis, // for handling overflow for very long texts
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                )),
          ),
          Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () {
                    print("go to edit profile");
                  },
                  icon: const Icon(Icons.edit)))
        ],
      );
}
