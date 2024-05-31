import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/screens/authentication_screens/sign_in_page.dart';
import 'package:elbi_donation_system/screens/donor_screens/organization_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorHomePage extends StatefulWidget {
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;
    User? loggedIn = context
        .read<UserAuthProvider>()
        .user; //it's read because there can only be one user who access the todo_page

    return StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          print("in Donor home page");
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("Error encountered! ${snapshot.error}"),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData) {
            return const SignInPage();
          }

          // if user is logged in, check what type of user they are
          return const OrganizationListPage();
        });
  }
}
