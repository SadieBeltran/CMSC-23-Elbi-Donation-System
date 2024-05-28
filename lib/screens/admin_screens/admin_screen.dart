import 'package:elbi_donation_system/screens/admin_screens/admin_donor_screen.dart';
import 'package:elbi_donation_system/screens/admin_screens/admin_organization_screen.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int myIndex = 0;
  List<Widget> widgetList = [
    Text("Org List"),
    Text("Approve Org List"),
    AdminDonorScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widgetList[myIndex]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.groups_2_outlined), label: 'Organizations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.approval_outlined), label: 'Approve Orgs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Donors'),
        ],
      ),
    );
    ;
  }
}
