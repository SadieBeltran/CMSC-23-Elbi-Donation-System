import 'package:flutter/material.dart';

class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  @override
  Widget build(BuildContext context) {
    int myIndex = 0;
    List<Widget> widgetList = const [
      Text("Donation Page"),
      Text("Donation Drive list"),
      Text("Profile")
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
                icon: Icon(Icons.groups_2_outlined), label: 'Donations'),
            BottomNavigationBarItem(
                icon: Icon(Icons.approval_outlined), label: 'Donation Drives'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: 'Profile')
          ],
        ));
  }
}
