import 'package:elbi_donation_system/data_models/organization.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Organization
      user; //PLACEHOLDER SHOULD BE CHANGED TO USER LATER OR MUST GET CURRENTLY LOGGED IN VIA FIREBASE AUTH
  const EditProfilePage({required this.user, super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _orgName;
  String? _description;
  List<dynamic>? _addresses;
  String? _contactNumber = "";
  List<bool> _enableAddressForm = [];

  @override
  void initState() {
    super.initState();
    _orgName = widget.user.organizationName;
    _addresses = widget.user.addresses;
    _description = widget.user.description;
    _contactNumber = widget.user.contactNumber;
    _enableAddressForm =
        List.generate(widget.user.addresses.length, (index) => false);
  }

  // ADD BUTTON TO REDIRECT TO EDIT ORGANIZATION also if-else statement to handle that by user-type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Donate'),
        ),
        drawer: const DrawerWidget(),
        body: SingleChildScrollView(
          child: Form(
            child: _formCol,
          ),
        ));
  }

  Widget get _formCol => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TO IMPLEMENT, CHANGE IMAGE
          // Image.asset(
          //   widget.user.orgImagePath,
          //   height: 250,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),

          _orgNameField,
          Column(
            children: [
              addressFields,
            ],
          ),
          _contactNumField,
          _descriptionFormField,
          const Text("Will implement the rest later...")
          // manage donationDrives... at another menu eheh
        ],
      );

  Widget get _orgNameField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          initialValue: widget.user.organizationName,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Organization Name"),
              hintText: "Enter your Organization's Name"),
          onSaved: (value) =>
              setState(() => /*name['firstName']*/ _orgName = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Organization's name must not be empty";
            }
            return null;
          },
        ),
      );

  Widget get _contactNumField => Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: TextFormField(
          initialValue: widget.user.contactNumber,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Contact No"),
              hintText: "Enter your contactNo "),
          onSaved: (value) =>
              setState(() => /*name['lastName']*/ _contactNumber = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "last name must not be empty";
            }
            return null;
          },
        ),
      );

  Widget get _descriptionFormField => Wrap(
        children: [
          TextFormField(
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(labelText: "Description"),
            initialValue: _description,
            maxLines: null,
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
          )
        ],
      );

  Widget addAddress() {
    TextEditingController newAddressController = TextEditingController();
    return ListTile(
      title: TextFormField(
        initialValue: "",
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          label: Text("Address"),
          hintText: "Enter your address",
        ),
        controller: newAddressController,
      ),
      trailing: TextButton.icon(
          onPressed: () {
            var value = newAddressController.text;
            if (value.isEmpty) {
              print("Address must not be empty");
            } else if (value.contains('\n')) {
              print("Address must not contain new lines!");
            } else if (value.length > 79) {
              print("Address must not exceed 79 characters!");
            }

            setState(() {
              _enableAddressForm.add(false);
              _addresses?.add(value);
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Address")),
    );
  }

  Widget get addressFields => ListView.builder(
        shrinkWrap: true,
        itemCount: widget.user.addresses.length,
        itemBuilder: ((context, index) {
          return Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: ListTile(
                title: TextFormField(
                  enabled: _enableAddressForm[index],
                  initialValue: widget.user.addresses[index],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Address"),
                    hintText: "Enter your address",
                  ),
                  onSaved: (value) => setState(() {
                    if (value != null && value.isNotEmpty) {
                      widget.user.addresses[index] = value;
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
                trailing: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _enableAddressForm[index] =
                                !_enableAddressForm[index];
                          });
                        },
                        icon: Icon(_enableAddressForm[index]
                            ? Icons.check
                            : Icons.edit)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            widget.user.addresses.removeAt(index);
                          });
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              ));
        }),
      );
}
