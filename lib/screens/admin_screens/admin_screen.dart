import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view.dart';
import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view_item.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:elbi_donation_system/screens/admin_screens/admin_donor_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

// INDEFINITELY LOADS, MIGHT HAVE SOMETHING TO DO WITH STREAMBUILDER BEING USED MORE THAN ONCE

class _AdminScreenState extends State<AdminScreen> {
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> orgStream =
        context.read<OrgListProvider>().approvedOrgs;
    Stream<QuerySnapshot> unapprovedstream =
        context.read<OrgListProvider>().unapproved;

    List<Widget> widgetList = [
      _approvedOrgsList(orgStream),
      _approvedOrgsList(unapprovedstream),
      const AdminDonorScreen(),
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

  StreamBuilder _approvedOrgsList(Stream<QuerySnapshot> org) {
    return StreamBuilder(
        stream: org,
        builder: (context, AsyncSnapshot snapshot) {
          print("entering if-else");
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No Todos Found"),
            );
          }

          print("exited if-else");
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              print("${snapshot.data?.docs[index].id}");
              Organization org = Organization.fromJson(
                  snapshot.data?.docs[index].data() as Map<String, dynamic>);
              print(org);
              org.uid = snapshot.data?.docs[index].id;
              return OrganizationsListViewItem(org: org);
            }),
          );
        });
  }

  // Widget get _notApprovedOrgsList =>
  //     const OrganizationsListView(isApproved: false);
}
