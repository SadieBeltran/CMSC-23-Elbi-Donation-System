import 'package:flutter_riverpod/flutter_riverpod.dart';
// dummy data
import 'package:elbi_donation_system/data/dummy_organizations.dart';
import 'package:elbi_donation_system/data/dummy_donors.dart';

// This provider will return the list of dummy contacts
final dummyDataProvider = Provider((ref) => dummyOrganizations);

final dummyDonorDataProvider = Provider((ref) => dummyDonors);
