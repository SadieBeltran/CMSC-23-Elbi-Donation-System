import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Organization
      user; //PLACEHOLDER SHOULD BE CHANGED TO USER LATER OR MUST GET CURRENTLY LOGGED IN VIA FIREBASE AUTH
  const EditProfilePage({required this.user, super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _name = "";
  String _username = "";
  List<String> _addresses = [];
  String _contactNumber = "";
  // ADD BUTTON TO REDIRECT TO EDIT ORGANIZATION also if-else statement to handle that by user-type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Donate'),
        ),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // TO IMPLEMENT, CHANGE IMAGE
              Image.asset(
                widget.user.orgImagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const Text("Will implement the rest later...")
            ],
          ),
        ));
  }
}
