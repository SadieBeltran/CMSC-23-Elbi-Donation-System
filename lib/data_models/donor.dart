import 'package:uuid/uuid.dart';

// utility object that generates unique id
const uuid = Uuid();

class Donor {
  // constructor
  Donor({
    required this.name,
    required this.username,
    required this.password,
    required this.addresses,
    required this.contactNumber,
  }) {
    // if the value of id is null, then the app will auto fill the id field
    id = id ?? uuid.v4();
  }

  // properties
  String? id;

  // properties
  final String name;
  final String username;
  final String password;
  final List<String> addresses;
  final String contactNumber;
}
