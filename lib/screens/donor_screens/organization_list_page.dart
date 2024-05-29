import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view.dart';
import 'package:elbi_donation_system/screens/donor_screens/profile_screen.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';

class OrganizationListPage extends StatelessWidget {
  const OrganizationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: 30,
            ),
            SizedBox(width: 10),
            Text('Organizations'),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
            },
            icon: const Icon(
              Icons.person_outline,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: const OrganizationsListView(
        isApproved: true,
      ),
    );
  }
}
