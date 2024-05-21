/*
  Worked on by: Beltran, Elysse Samantha T.
  Desc: Contains the Sign Up form. When a user tries to access the app without being logged in, they should be redirected here. Features included should be: Name, Username, Password, Address/es, Contact No, type of user (can be organization or donor), if organization, should include name of org and proof of legitimacy

  Notes: Will need to establish a cloud firestore db in order to record this. Currently has no backend.
 */
import 'package:elbi_donation_system/data_models/donor.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/donor_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool isOrganization = false; //default is donor.

// for the data that Form will record
  String? email;
  // Map<String, String?> name = {'firstName': "", 'lastName': ""};
  String? firstName;
  String? lastName;
  String? userName;
  String? password;
  List<String>? addresses;
  String? contactNo;
  int typeOfUser = 0; //0 means donor, 1 means organization
  String? nameOfOrg;
  // String? proofOfLegitimacy; //I think images should be implemented later on... (kinda a pain to think about)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(30),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      heading,
                      emailField,
                      passwordField,
                      firstNameField,
                      lastNameField,
                      contactNum,
                      orgName,
                      submitButton
                    ],
                  ))),
        ));
  }

  Widget get heading => const Padding(
        padding: EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      );

  Widget get emailField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Email"),
              hintText: "Enter a valid email"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            RegExp regex = RegExp(
                r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"); //https://regexr.com/3e48o
            if (value == null || value.isEmpty) {
              return "Email field must not be empty";
            } else if (!regex.hasMatch(value)) {
              return "Please enter a valid email format";
            }
            return null;
          },
        ),
      );

  Widget get passwordField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              hintText: "At least 8 characters"),
          obscureText: true,
          onSaved: (value) => setState(() => password = value),
          validator: (value) {
            RegExp regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$");
            if (value == null || value.isEmpty) {
              return "Please enter a valid password";
            } else if (!regex.hasMatch(value)) {
              //https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
              return "Password must have minimum 6 characters, at least one letter, and one number";
            }
            return null;
          },
        ),
      );

  Widget get firstNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("First Name"),
              hintText: "Enter your First Name"),
          onSaved: (value) =>
              setState(() => /*name['firstName']*/ firstName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "First Name must not be empty";
            }
            return null;
          },
        ),
      );

  Widget get lastNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Last Name"),
              hintText: "Enter your last name"),
          onSaved: (value) =>
              setState(() => /*name['lastName']*/ lastName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "last name must not be empty";
            }
            return null;
          },
        ),
      );

// might want to change it to <dropdown> <number field> for convenience
  // Widget get contactNum => textFormFieldGenerator(
  //     RegExp(r"^(\+639|09)\d{9}$"),
  //     "Contact Number",
  //     "09123456789",
  //     "must either start with 09 or +639 and end with 9 digits",
  //     contactNo);

  Widget get contactNum => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Contact No"),
              hintText: "Enter your contactNo "),
          onSaved: (value) =>
              setState(() => /*name['lastName']*/ contactNo = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "last name must not be empty";
            }
            return null;
          },
        ),
      );

  Widget get address => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text('Address'),
              hintText: "Insert organization name here"),
          onSaved: (value) => setState(() => addresses?.add(value!)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Address must not be empty";
            } else if (RegExp(r"^[^\n]{0,79}$").hasMatch(value)) {
              return "Address must not contain new lines and must not exceed 79 characters!";
            }
            return null;
          },
        ),
      );

  Widget get orgName => textFormFieldGenerator(
      RegExp(r"^[^\n]{0,79}$"),
      "Organization Name",
      "Insert organization name here",
      "must not contain new lines and must not exceed 79 characters!",
      nameOfOrg);

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          await context
              .read<UserAuthProvider>()
              .authService
              .signUp(email!, password!);

          Donor newDonor = Donor(
              id: context.read<UserAuthProvider>().uid,
              firstName: firstName!,
              lastName: lastName!,
              username: email!,
              // addresses: addresses!,
              contactNumber: contactNo!);
          print(newDonor);
          await context.read<DonorListProvider>().addDonor(newDonor);
        }
        //   // check if the widget hasn't been disposed of after an asynchronous action
        //   if (mounted) Navigator.pop(context); //go back to the signin page?
        // }
      },
      child: const Text("Sign Up"));

  Padding textFormFieldGenerator(regex, label, hintText, errorText, data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextFormField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(label),
            hintText: hintText),
        onSaved: (value) => setState(() => data = value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label must not be empty";
          } else if (!regex.hasMatch(value)) {
            return "$label $errorText";
          }
          return null;
        },
      ),
    );
  }
}
