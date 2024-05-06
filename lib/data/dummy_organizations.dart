// data model
import 'package:elbi_donation_system/data_models/organization.dart';

// dummy list of organizations
final List<Organization> dummyOrganizations = [
  Organization(
    name: 'Pastor Agila',
    username: 'pastor_agila',
    password: '123456789',
    addresses: ['Socorro, Surigao del Norte, Philippines'],
    contactNumber: '0998765432',
    organizationName: 'Socorro Bayanihan Services, Inc.',
    proofsOfLegitimacy: [],
    orgImagePath: 'assets\images\org_images\kulto.png',
  ),
  Organization(
    name: 'Bob Jones',
    username: 'earthIsFlat',
    password: '123456789',
    addresses: ['Florida, USA'],
    contactNumber: '0998765432',
    organizationName: 'Flat Earthers',
    proofsOfLegitimacy: [],
    orgImagePath: 'assets\images\org_images\isis.jpg',
  ),
  Organization(
    name: 'Abdul Ahmed',
    username: 'abdul_ahmed',
    password: '123456789',
    addresses: ['Somewhere in Iraq'],
    contactNumber: '0912345678',
    organizationName: 'ISIS',
    proofsOfLegitimacy: [],
    orgImagePath: 'assets\images\org_images\isis.jpg',
  ),
];
