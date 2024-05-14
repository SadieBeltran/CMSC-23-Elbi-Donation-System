import 'package:elbi_donation_system/custom_widgets/donor_views/homepage/donors_list_view_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// data model
import 'package:elbi_donation_system/data_models/donor.dart';
// provider
import 'package:elbi_donation_system/providers/dummy_data_provider.dart';

class DonorsListView extends ConsumerWidget {
  const DonorsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // get the list of organizations from the provider
    final List<Donor> donorsList = ref.watch(dummyDonorDataProvider);

    return ListView.builder(
      itemCount: donorsList.length,
      itemBuilder: (ctx, index) => DonorsListViewItem(
        donor: donorsList[index],
      ),
    );
  }
}
