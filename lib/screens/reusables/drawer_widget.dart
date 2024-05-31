/*  */
import 'package:elbi_donation_system/screens/admin_screens/admin_screen.dart';
import 'package:elbi_donation_system/screens/authentication_screens/sign_in_page.dart';
import 'package:elbi_donation_system/screens/authentication_screens/sign_up_page_donor.dart';
import 'package:elbi_donation_system/screens/donor_screens/donor_home_page.dart';
import 'package:elbi_donation_system/screens/organization_screens/org_home_page.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.white),
        child: Text(
          "Elbi Donation System",
          style: TextStyle(color: Colors.black),
        ),
      ),
      ListTile(
          title: const Text("Sign In"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInPage()));
          }),
      ListTile(
          title: const Text("Sign Up"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignUpDonorPage()));
          }),
      ListTile(
          title: const Text("Donate"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const DonorHomePage()));
          }),
      ListTile(
          title: const Text("Admin Screen"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AdminScreen()));
          }),
      ListTile(
          title: const Text("Org Home Screen"),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrgHomePage()));
          }),
    ]));
  }
}
