import 'package:flutter_riverpod/flutter_riverpod.dart';
// dummy data
import 'package:elbi_donation_system/data/dummy_organizations.dart';

// This provider will return the list of dummy contacts
final dummyDataProvider = Provider((ref) => dummyOrganizations);