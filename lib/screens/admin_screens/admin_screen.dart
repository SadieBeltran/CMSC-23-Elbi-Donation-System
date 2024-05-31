import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view_item.dart';
import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/unapproved_organizations_list_view.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:elbi_donation_system/screens/admin_screens/admin_donor_screen.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart' show StreamZip;
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> orgStream =
        context.watch<OrgListProvider>().approvedOrgs;
    Stream<QuerySnapshot> unapprovedStream =
        context.watch<OrgListProvider>().unapproved;

    List<Widget> widgetList = [
      _orgsList(orgStream),
      _orgsList(unapprovedStream),
      const AdminDonorScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
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
              icon: Icon(Icons.groups_2_outlined), label: 'Organizations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.approval_outlined), label: 'Approve Orgs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: 'Donors'),
        ],
      ),
    );
  }

  Widget _orgsList(Stream<QuerySnapshot> orgStream) {
    return StreamBuilder(
      stream: orgStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error encountered! ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Organizations Found"),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              Organization org = Organization.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              org.uid = snapshot.data?.docs[index].id;
              return OrganizationsListViewItem(org: org);
            },
          );
        }
      },
    );
  }
}
