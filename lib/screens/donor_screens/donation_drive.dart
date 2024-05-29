import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/screens/reusables/edit_donation_drive.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:elbi_donation_system/data_models/donation_item.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class DonationDrivePage extends StatefulWidget {
  final DonationDrive drive;
  const DonationDrivePage({required this.drive, super.key});

  @override
  State<DonationDrivePage> createState() => _DonationDrivePageState();
}

class _DonationDrivePageState extends State<DonationDrivePage> {
  final int _userType = 0; //0 - "owner", 1 = "donor", 2 - "admin"
  bool _showDonationForm = false;
  final _formKey = GlobalKey<FormState>();
  bool _isPickUp = true;
  double _weight = 0;
  DateTime _pickUpTime = DateTime.now();
  final List<String> _address = [];
  String _contactNumber = "";
  bool _isEnabled = false;
  final List<TextEditingController> _addressText = [TextEditingController()];
  final List<String> _donationTypes = [
    "Clothes",
    "Food",
    "Cash",
    "Necessities"
  ];
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
        title: Text(widget.drive.driveName),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Org Details
          // org image
          Image.asset(
            'assets/images/org_images/kulto.png',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          driveContent(widget.drive),
          _userType == 1
              ? TextButton(
                  onPressed: () {
                    setState(() {
                      _showDonationForm = true;
                    });
                  },
                  child: const Text("Donate"))
              : Container(), //show donations in else
          _showDonationForm ? donationForm() : Container()
        ]),
      ),
    );
  }

  Widget driveContent(DonationDrive drive) {
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
        children: [driveName, driveDescription, driveDuration, _driveStatus],
      ),
    );
  }

  String _getStatus(int code) {
    switch (code) {
      case 0:
        return "Setting Up";
      case 1:
        return "Ongoing";
      case 2:
        return "Finished";
    }
    return "";
  }

  Widget get driveDuration => Row(
        children: [
          Expanded(
              flex: 1,
              child: ListTile(
                  leading: const Text("Start"),
                  title: Text(DateFormat('yyyy-MM-dd')
                      .format(widget.drive.startDate)))),
          const Divider(
            thickness: 2,
            color: Colors.grey,
          ),
          Expanded(
              flex: 1,
              child: ListTile(
                  leading: const Text("End:"),
                  title: Text(
                      DateFormat('yyyy-MM-dd').format(widget.drive.endDate))))
        ],
      );

  Widget get _driveStatus => ListTile(
      leading: const Text("Status:"),
      title: Text(
        _getStatus(widget.drive.status),
      ));

  Widget get driveDescription => Wrap(
        children: [Text(widget.drive.description)],
      );

  Widget get driveName => Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
                //ORGANIZATION NAME
                widget.drive.driveName,
                textAlign: TextAlign.start,
                softWrap: true,
                overflow: TextOverflow
                    .ellipsis, // for handling overflow for very long texts
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                )),
          ),
          _userType == 0 || _userType == 2
              ? Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              EditDonationDrivePage(drive: widget.drive),
                        ),
                      );
                    },
                  ))
              : Container()
        ],
      );

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
          print(newDonation);
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
