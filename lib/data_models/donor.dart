class Donor {
  // constructor
  Donor({
    required this.name,
    required this.username,
    required this.password,
    required this.addresses,
    required this.contactNumber,
  });

  // properties
  final String name;
  final String username;
  final String password;
  final List<String> addresses;
  final String contactNumber;
}