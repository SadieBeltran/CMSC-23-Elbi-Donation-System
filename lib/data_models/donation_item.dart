import 'dart:convert';

class DonationItem {
  String? id;
  List<String>? donationType;
  bool isPickUp; //default is pick-up
  double weight;
  DateTime time; //FOR PICKUP/DROP-OFF
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
  }) {
    // isPickUp = true;
    // time = DateTime.now();
    status = 0;
  }

  factory DonationItem.fromJson(Map<String, dynamic> json) {
    return DonationItem(
      id: json['id'],
      donationType: json['firstName'],
      isPickUp: json['lastName'],
      weight: json['email'],
      time: json['todos'],
      address: json['address'],
      contactNumber: json['contactNumber'],
      status: json['status'],
    );
  }

  static List<DonationItem> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data
        .map<DonationItem>((dynamic d) => DonationItem.fromJson(d))
        .toList();
  }

//Will be used to add to db by firebase_Users_api.dart
  Map<String, dynamic> toJson(DonationItem item) {
    return {
      'donationType': item.donationType,
      'isPickUp': item.isPickUp,
      'weight': item.weight,
      'time': item.time,
      'address': item.address,
      'contactNumber': item.contactNumber,
      'status': item.status
    };
  }
}
