// this is the model for user.
import 'donation_item.dart';
import 'donation_drive.dart';

class AppUser {
  String? id;
  String firstName;
  String lastName;
  String email;
  String userName;
  int? userType; //0 by default, 1 if organization, 2 if admin
  List<String>? userAddress;
  String contactNumber;

  AppUser(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.userName,
      required this.userType,
      this.userAddress,
      required this.contactNumber});
}

class Organization extends AppUser {
  String? orgId;
  List<DonationItem>? donatedItems;
  List<DonationDrive>? donationDrives;
  String? organizationDescription;
  bool isVerified; //if org is approved by admin or not

  Organization({
    super.userType, //usertype is 1 for this
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.userName,
    required super.contactNumber,
    this.orgId,
    this.donatedItems,
    this.donationDrives,
    this.organizationDescription,
    required this.isVerified,
  }) {
    super.userType = 1;
  }
}

class Admin extends AppUser {
  Admin({
    super.userType, //usertype is 2 for this
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.userName,
    required super.contactNumber,
  }) {
    super.userType = 2;
  }
}
