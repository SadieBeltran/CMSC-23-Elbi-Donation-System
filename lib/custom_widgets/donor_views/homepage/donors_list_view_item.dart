import 'package:elbi_donation_system/data_models/donor.dart';
import 'package:flutter/material.dart';
// screens

class DonorsListViewItem extends StatelessWidget {
  const DonorsListViewItem({
    required this.donor,
    super.key,
  });

  // properties
  final Donor donor;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: ListTile(
          title: Text(
            donor.name,
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow
                .ellipsis, // for handling overflow for very long texts
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward),
        ));
  }
}
