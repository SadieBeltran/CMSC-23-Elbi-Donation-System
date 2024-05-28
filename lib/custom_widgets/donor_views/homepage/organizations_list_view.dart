import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/organizations_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// data model
import 'package:elbi_donation_system/data_models/organization.dart';
// provider
import 'package:elbi_donation_system/providers/dummy_data_provider.dart';

// class OrganizationsListView extends ConsumerWidget {
//   const OrganizationsListView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // get the list of organizations from the provider
//     // final List<Organization> organizationsList = ref.watch(dummyDataProvider);

//     return ListView.builder(
//       itemCount: organizationsList.length,
//       itemBuilder: (ctx, index) => OrganizationsListViewItem(
//         org: organizationsList[index],
//       ),
//     );
//   }
// }
