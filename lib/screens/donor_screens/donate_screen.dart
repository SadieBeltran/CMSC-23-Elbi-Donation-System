// import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/data_models/donation_item.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// data model
import 'package:elbi_donation_system/data_models/organization.dart';

class DonateScreen extends StatefulWidget {
  final Organization org;
  const DonateScreen({required this.org, super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  final List<String> _donationTypes = [
    "Clothes",
    "Food",
    "Cash",
    "Necessities"
  ];
  final _formKey = GlobalKey<FormState>();
  bool _isPickUp = true;
  double _weight = 0;
  DateTime _pickUpTime = DateTime.now();
  final List<String> _address = [];
  String _contactNumber = "";
  bool _isEnabled = false;
  final List<TextEditingController> _addressText = [TextEditingController()];
  @override
  void dispose() {
    for (var elem in _addressText) {
      elem.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate'),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Org Details
            // org image
            Hero(
              tag: widget.org.id!,
              child: Image.asset(
                widget.org.orgImagePath,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // container for adding margin
            Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // more details about the org
                  // container for the black background
                  organizationInfo(widget.org),
                  // Donation Input Fields
                  const Divider(
                    thickness: 4,
                    color: Colors.grey,
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                      child: donationForm())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget donationDriveList(Organization org) {
    return Wrap(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount:
                org.donationDrives == null ? 0 : org.donationDrives!.length,
            itemBuilder: (context, index) {
              return GridTile(
                child: InkResponse(
                    child: Text(org.donationDrives![index].driveName),
                    onTap: () {}),
              );
            })
      ],
    );
  }

  Widget organizationInfo(Organization org) {
    return Container(
      margin: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: const BoxDecoration(
        // color: Colors.black45,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            //ORGANIZATION NAME
            org.organizationName,
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow
                .ellipsis, // for handling overflow for very long texts
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          //Addresses (Make this a ListView.builder, to be changed into Streambuilder later)
          const Text(
            "Addresses",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: org.addresses.length,
            itemBuilder: ((context, index) {
              return ListTile(
                  title: Text(org.addresses[index]),
                  leading: const Icon(Icons.location_city_outlined));
            }),
          ),
          //username
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(org.username),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: Text(org.contactNumber),
          )
          //phoneNumber
        ],
      ),
    );
  }

  Widget donationDrives(Organization org) {
    //Listview.builder of org's donation drives, make them clickable buttons.
    return Container();
  }

//form should be moved to donationdrive...
  Form donationForm() {
    //will need to upload to cloudFirestore
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //Title
          const Text(
            "Donate Here",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Column(
            children: [
              //Checkbox list of item type for donationType. Must not be empty
              //is pickUp on-off switch
              //weight
              //time is automatically recorded
              //Choose Donation Drive
              //Button to save
              donationTypeForm(),
              pickUpSwitch(),
              weightFormField,
              dateFormField(),
              addressFormField(),
              contactNumberFormField(),
              submitButton
            ],
          )
        ],
      ),
    );
  }

  Widget get submitButton => ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          DonationItem newDonation = DonationItem(
              donationType: _donationTypes,
              isPickUp: _isPickUp,
              weight: _weight,
              time: _pickUpTime,
              address: _address,
              contactNumber: _contactNumber,
              status: 0);
          print(DonationItem);
        }
      },
      child: const Text("Sign Up"));

  Widget contactNumberFormField() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: "Input contact number", hintText: "09123456789"),
      validator: (value) {
        RegExp reg = RegExp(r"(09|\+639)\d{9}");
        if (value == null || value.isEmpty) {
          return "Contact Number must be filled";
        } else if (!reg.hasMatch(value)) {
          return "Please enter a proper contact number";
        }
        return null;
      },
      onSaved: (value) => setState(() {
        _contactNumber = value!;
      }),
    );
  }

  Column addressFormField() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _address.length,
          itemBuilder: (context, index) {
            return ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        child: const Icon(Icons.edit),
                        onTap: () {
                          setState(() {
                            if (!_isEnabled) {
                              _isEnabled = !_isEnabled;
                            }
                          });
                          print("can now edity");
                        }),
                    GestureDetector(
                        child: const Icon(Icons.check),
                        onTap: () {
                          setState(() {
                            if (_isEnabled) {
                              _isEnabled = !_isEnabled;
                            }
                            _address[index] = _addressText[index + 1].text;
                          });
                          print("done editing");
                          print(_address);
                        })
                  ],
                ),
                title: TextField(
                  enabled: _isEnabled,
                  controller: _addressText[index + 1],
                  decoration: InputDecoration(
                      hintStyle: _isEnabled
                          ? const TextStyle(color: Colors.black)
                          : const TextStyle(color: Colors.green),
                      hintText: _address[index]),
                  onEditingComplete: () {
                    setState(() {
                      _isEnabled = !_isEnabled;
                    });
                  },
                ));
          },
        ),
        Row(
          //https://stackoverflow.com/questions/60380046/how-to-apply-flex-in-flutter
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Input address for pickup"),
                  controller: _addressText[0]),
            ),
            Expanded(
                flex: 1,
                child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: () {
                      // Regex validator reference https://regex101.com/r/q6LoSE/4 to preventr code injection
                      var value = _addressText[0].text;
                      RegExp reg = RegExp(r"^[\w\s ,.]+$");
                      if (value.isEmpty) {
                        print("Address field must contain something");
                      } else if (!reg.hasMatch(value)) {
                        print("Please input a valid address");
                      } else {
                        setState(() {
                          _addressText.add(TextEditingController());
                          _address.add(value);
                        });
                      }
                    },
                    label: const Text("Add address")))
          ],
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // https://stackoverflow.com/questions/56613875/datetime-comparison-in-dart
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _pickUpTime,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        (picked.isAfter(_pickUpTime) || picked == _pickUpTime)) {
      setState(() {
        _pickUpTime = picked;
      });
    }
  }

// https://levelup.gitconnected.com/date-picker-in-flutter-ec6080f3508a
// https://api.flutter.dev/flutter/intl/DateFormat-class.html
  Widget dateFormField() {
    String dateValue = DateFormat('yyyy-MM-dd').format(_pickUpTime);
    return TextFormField(
        decoration: InputDecoration(
            labelText: "${_isPickUp ? "pick up" : "drop off"} date: $dateValue",
            hintText: dateValue),
        onTap: () => _selectDate(context));
  }

  TextFormField get weightFormField => TextFormField(
        decoration: const InputDecoration(labelText: "Input weight (g)"),
        onSaved: (value) => setState(() {
          _weight = double.parse(value!);
        }),
        validator: (value) {
          RegExp reg = RegExp(r"^[0-9]+(\.[0-9]*)?");
          if (value == null || value.isEmpty) {
            return "Weight field must contain a value";
          } else if (!reg.hasMatch(value)) {
            return "Input must be a valid number or decimal";
          }
          return null;
        },
      );

  Row pickUpSwitch() {
    return Row(
      children: [
        const Text("Pick Up"),
        Switch(
          value: _isPickUp,
          activeColor: Colors.green,
          onChanged: (bool value) {
            setState(() {
              _isPickUp = value;
            });
          },
        ),
        const Text("Drop Off")
      ],
    );
  }

  List<Widget> foorbar() {
    // https://stackoverflow.com/questions/55039861/creating-a-list-of-widgets-from-map-with-keys-and-values
    // OH GOD THAT TOOK LONGER THAN NECESSARY
    return _donationTypes.map((entry) {
      var w = TextButton.icon(
          icon: const Icon(Icons.close),
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              side: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
          onPressed: () {
            setState(() => _donationTypes.remove(entry));
            print(_donationTypes);
          },
          label: Text(entry));
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: w,
      );
    }).toList();
  }

  Column donationTypeForm() {
    var _donationText = TextEditingController();

    return Column(
      children: [
        Wrap(children: [
          ...foorbar(), //https://stackoverflow.com/questions/60029677/how-to-use-the-children-widget-of-a-row-to-display-a-list-of-icons
          TextButton.icon(
              icon: const Icon(Icons.add),
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
              ),
              onPressed: () {
                var value = _donationText.text.toLowerCase().trim();
                if (_donationTypes.length >= 20) {
                  print("Only a maximum of 20 tags can be added");
                } else if (_donationTypes.contains(value)) {
                  //needs to rework
                  print("Donation Type already exists");
                } else if (value.isEmpty) {
                  print("Field must not be empty");
                } else {
                  setState(() {
                    _donationTypes.add(_donationText.text);
                  });
                }
              },
              label: const Text("Add Type"))
        ]),
        TextFormField(
          decoration: const InputDecoration(labelText: "Add another type"),
          controller: _donationText,
        )
      ],
    );
  }
}
