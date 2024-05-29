import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view.dart';
import 'package:elbi_donation_system/screens/admin_screens/admin_donor_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      _approvedOrgsList,
      _notApprovedOrgsList,
      AdminDonorScreen(),
    ];
    return Scaffold(
      body: Center(child: widgetList[myIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_2_outlined), label: 'Organizations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.approval_outlined), label: 'Approve Orgs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Donors'),
        ],
      ),
    );
  }

  Widget get _approvedOrgsList => const OrganizationsListView(isApproved: true);
  Widget get _notApprovedOrgsList =>
      const OrganizationsListView(isApproved: false);
}
