/*
  Worked on by: Beltran, Elysse Samantha T.
  Desc: Contains the Sign Up form. When a user tries to access the app without being logged in, they should be redirected here. Features included should be: Name, Username, Password, Address/es, Contact No, type of user (can be organization or donor), if organization, should include name of org and proof of legitimacy

  Notes: Will need to establish a cloud firestore db in order to record this. Currently has no backend.
 */
import 'dart:io';

import 'package:elbi_donation_system/data_models/app_user.dart';
import 'package:elbi_donation_system/data_models/donor.dart';
import 'package:elbi_donation_system/providers/app_user_provider.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/screens/authentication_screens/sign_up_page_org.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/donor_provider.dart';

class SignUpDonorPage extends StatefulWidget {
  const SignUpDonorPage({super.key});

  @override
  State<SignUpDonorPage> createState() => _SignUpDonorPageState();
}

class _SignUpDonorPageState extends State<SignUpDonorPage> {
  final _formKey = GlobalKey<FormState>();
  bool isOrganization = false; //default is donor.

// for the data that Form will record
  String? email;
  // Map<String, String?> name = {'firstName': "", 'lastName': ""};
  String? firstName;
  String? lastName;
  String? userName;
  String? password;
  String? profilePic;
  int _tapCount = 0;
  bool _asAdmin = false;
  List<String>? addresses;
  List<TextEditingController> addressControllers = [TextEditingController()];
  String? contactNo;
  int typeOfUser = 0; //0 means donor, 1 means organization
  String? nameOfOrg;
  // String? proofOfLegitimacy; //I think images should be implemented later on... (kinda a pain to think about)
  String? usernameError;

  @override
  void dispose() {
    for (var controller in addressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
                      // userNameField,
                      Row(
                        children: [
                          firstNameField,
                          lastNameField,
                        ],
                      ),
                      contactNum,
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      ...addressFields,
                      addAddressButton,
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      // orgName,
                      submitButton,
                      signUpOrgButton
                    ],
                  ))),
        ));
  }

  Widget get proofOfLegitimacyBtn => Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
              ),
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                print('${file?.path}');

                if (file == null) return;
                String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages = referenceRoot.child('images');
                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueFileName);
                try {
                  await referenceImageToUpload.putFile(File(file.path));
                  profilePic = await referenceImageToUpload.getDownloadURL();
                } catch (err) {
                  AlertDialog(
                    title: const Text("Error"),
                    content: Text("$err"),
                  );
                }
              },
              label: const Text("Upload profile pic"),
              icon: const Icon(Icons.camera_alt))
        ],
      ));

  Widget get heading => InkWell(
      onTap: () {
        setState(() {
          _tapCount++;
          if (_tapCount == 5) {
            typeOfUser = 2;
            _asAdmin = !_asAdmin;
            _tapCount = 0;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(
          "Sign Up${_asAdmin ? " as Admin" : ""}",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ));

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

  Widget get firstNameField => Expanded(
        flex: 1,
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

  Widget get lastNameField => Expanded(
        flex: 1,
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

  Widget get signUpOrgButton => Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text("No account yet?"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpOrgPage()));
                },
                child: const Text("Sign Up as an Organization"))
          ],
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

  List<Widget> get addressFields => addressControllers
      .map((controller) => Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Address"),
                hintText: "Enter your address",
              ),
              onSaved: (value) => setState(() {
                if (value != null && value.isNotEmpty) {
                  addresses?.add(value);
                }
              }),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Address must not be empty";
                } else if (value.contains('\n')) {
                  return "Address must not contain new lines!";
                } else if (value.length > 79) {
                  return "Address must not exceed 79 characters!";
                }
                return null;
              },
            ),
          ))
      .toList();

  Widget get addAddressButton => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              addressControllers.add(TextEditingController());
            });
          },
          child: const Text("Add Another Address"),
        ),
      );

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          print(
              "${firstName}, ${lastName}, ${email}, ${addresses}, ${contactNo}");

          _formKey.currentState!.save();

          await context
              .read<UserAuthProvider>()
              .authService
              .signUp(email!, password!);

          AppUser newAppUser = AppUser(
              id: context.read<UserAuthProvider>().uid, userType: typeOfUser);

          Donor newDonor = Donor(
              uid: context.read<UserAuthProvider>().uid,
              firstName: firstName!,
              lastName: lastName!,
              userName: email!,
              profilePicture: profilePic,
              addresses: addressControllers
                  .map((controller) => controller.text)
                  .toList(),
              contactNumber: contactNo!);

          mounted
              ? await context.read<DonorListProvider>().addDonor(newDonor)
              : null;
          mounted
              ? await context.read<AppUserProvider>().addAppUser(newAppUser)
              : null;
          mounted ? Navigator.pop(context) : null;
        }
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
