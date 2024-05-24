import 'dart:convert';
import 'dart:ffi';

class DonationItem {
  String? id;
  List<String>? donationType;
  bool isPickUp; //default is pick-up
  Float weight;
  DateTime time;
  List<String>? address;
  String contactNumber;
  int status; //0 - pending, 1- confirmed

  DonationItem({
    this.id,
    this.donationType,
    required this.isPickUp,
    required this.weight,
    required this.time,
    this.address,
    required this.contactNumber,
    required this.status,
  });
}
