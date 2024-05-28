import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view.dart';
import 'package:elbi_donation_system/screens/donor_screens/profile_screen.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// data model
import 'package:elbi_donation_system/data_models/organization.dart';
// provider
import 'package:elbi_donation_system/providers/dummy_data_provider.dart';

class DonorHomePage extends ConsumerWidget {
  const DonorHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the list of organizations from the provider
    final List<Organization> organizationsList = ref.watch(dummyDataProvider);
    const double iconSize = 30;

    // this variable will hold the content to be shown on the body of the Scaffold()
    late Widget bodyContent;

    // identify the content to be shown in this screen
    if (organizationsList.isNotEmpty) {
      bodyContent = OrganizationsListView();
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
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ProfileScreen()));
            },
            icon: const Icon(
              Icons.person_outline,
              size: iconSize,
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: bodyContent,
    );
  }
}
