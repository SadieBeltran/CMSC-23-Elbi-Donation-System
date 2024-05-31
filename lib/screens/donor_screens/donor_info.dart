import 'package:elbi_donation_system/data_models/donor.dart';
import 'package:flutter/material.dart';

class DonorInfo extends StatelessWidget {
  final Donor donor;
  const DonorInfo({required this.donor, super.key});

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
            donor.profilePicture != null
                ? Image.network(
                    donor.profilePicture!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(),
            _donorUsername,
            _addresses,
            _legalName,
            _contactNumber,
          ]),
    );
  }

  Widget get _addresses => ListView.builder(
        shrinkWrap: true,
        itemCount: donor.addresses.length,
        itemBuilder: ((context, index) {
          return ListTile(
              title: Text(donor.addresses[index]),
              leading: const Icon(Icons.location_city_outlined));
        }),
      );

  Widget get _contactNumber => ListTile(
      leading: const Icon(Icons.phone), title: Text(donor.contactNumber));

  Widget get _legalName => ListTile(
        leading: const Text("Name"),
        title: Text("${donor.firstName} ${donor.lastName}"),
      );

  Widget get _donorUsername => Row(
        children: [
          Expanded(
            flex: 1,
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  //ORGANIZATION NAME
                  donor.userName,
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
