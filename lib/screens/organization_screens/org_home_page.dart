import 'package:elbi_donation_system/custom_widgets/organization_info.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/screens/donor_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = const [
      Text("Donation Page"),
      Text("Donation Drive list"),
      ProfileScreen()
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Welcome, organization!'),
          actions: [
            IconButton(
                onPressed: () {
                  // logout
                  context.read<UserAuthProvider>().signOut();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
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
                icon: Icon(Icons.groups_2_outlined), label: 'Donations'),
            BottomNavigationBarItem(
                icon: Icon(Icons.approval_outlined), label: 'Donation Drives'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: 'Profile')
          ],
        ));
  }
}
