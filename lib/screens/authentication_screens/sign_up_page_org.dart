import 'dart:io';
import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/screens/authentication_screens/sign_up_page_donor.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/org_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpOrgPage extends StatefulWidget {
  const SignUpOrgPage({super.key});

  @override
  State<SignUpOrgPage> createState() => _SignUpOrgPageState();
}

class _SignUpOrgPageState extends State<SignUpOrgPage> {
  final _formKey = GlobalKey<FormState>();
  bool isOrganization = false; //default is donor.

// for the data that Form will record
  String? email;
  String? _description;
  String? orgName;
  String? password;
  List<String>? addresses;
  List<TextEditingController> addressControllers = [TextEditingController()];
  String? contactNo;
  // int typeOfUser = 0; //0 means donor, 1 means organization
  bool accepted = false;
  String? nameOfOrg;
  String? imageUrl;

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
                      orgNameField,
                      contactNum,
                      ...addressFields,
                      addAddressButton,
                      _descriptionFormField,
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      proofOfLegitimacyBtn,
                      submitButton,
                      signUpDonateButton
                    ],
                  ))),
        ));
  }

  Widget get _descriptionFormField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Description"),
              hintText: "Describe your organization"),
          onSaved: (value) => setState(() => email = value),
          validator: (value) {
            RegExp reg = RegExp(r"^(.|\s)*[a-zA-Z]+(.|\s)*$");
            if (value == null || value.isEmpty) {
              return "Address field must contain something";
            } else if (!reg.hasMatch(value)) {
              return "Please input a valid address";
            } else {
              setState(() {
                _description = value;
              });
            }
            return null;
          },
        ),
      );

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
                  imageUrl = await referenceImageToUpload.getDownloadURL();
                } catch (err) {
                  AlertDialog(
                    title: const Text("Error"),
                    content: Text("$err"),
                  );
                }
              },
              label: const Text("Upload proof of validity"),
              icon: const Icon(Icons.camera_alt))
        ],
      ));

  Widget get orgNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Organization Name"),
              hintText: "Enter your Organization's Name"),
          onSaved: (value) =>
              setState(() => /*name['firstName']*/ orgName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Organization's name must not be empty";
            }
            return null;
          },
        ),
      );

  Widget get signUpDonateButton => Padding(
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
                          builder: (context) => const SignUpDonorPage()));
                },
                child: const Text("Sign Up as a Donor"))
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
          if (imageUrl?.isEmpty ?? true) {
            return;
          }
          _formKey.currentState!.save();

          await context
              .read<UserAuthProvider>()
              .authService
              .signUp(email!, password!);

          Organization newOrg = Organization(
            uid: context.read<UserAuthProvider>().uid,
            organizationName: orgName!,
            addresses: addressControllers
                .map((controller) => controller.text)
                .toList(),
            description: _description,
            contactNumber: contactNo!,
            proofOfLegitimacy: imageUrl!,
            accepted: accepted,
          );

          print(
              '${newOrg.uid}, ${newOrg.organizationName}, ${newOrg.description}, ${newOrg.addresses}, ${newOrg.contactNumber}, ${newOrg.proofOfLegitimacy}, ${newOrg.accepted},');
          mounted ? await context.read<OrgListProvider>().addOrg(newOrg) : null;
        }
        //   // check if the widget hasn't been disposed of after an asynchronous action
        mounted ? Navigator.pop(context) : null; //go back to the signin page?
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
