import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view_item.dart';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationsListView extends StatefulWidget {
  const OrganizationsListView({super.key});

  @override
  State<OrganizationsListView> createState() => _OrganizationsListViewState();
}

class _OrganizationsListViewState extends State<OrganizationsListView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context.read<OrgListProvider>().approvedOrgs,
        builder: (context, AsyncSnapshot snapshot) {
          print("Orgs List: entering if-else length...");
          print(snapshot.data?.docs.length);
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
}
