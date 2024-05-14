import 'package:elbi_donation_system/providers/dummy_data_provider.dart';
import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/donors_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// data model
import 'package:elbi_donation_system/data_models/donor.dart';

class AdminDonorScreen extends ConsumerWidget {
  const AdminDonorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Donor> donorsList = ref.watch(dummyDonorDataProvider);

    const double iconSize = 30;

    // this variable will hold the content to be shown on the body of the Scaffold()
    late Widget bodyContent;

    if (donorsList.isNotEmpty) {
      bodyContent = DonorsListView();
    } else {}

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: iconSize,
            ),
            SizedBox(width: 10),
            Text('Organizations'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline,
              size: iconSize,
            ),
          ),
        ],
      ),
      body: bodyContent,
    );
  }
}
