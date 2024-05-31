import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/providers/donation_drive_provider.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// BUGGY: ONSAVED DOESN'T WORK YET MIGHT HAVE SOMETHING TO DO WITH HOW DUMMY ORG WORKS

class CreateDonationDrivePage extends StatefulWidget {
  final String orgId; //will add DocumentReference to this
  const CreateDonationDrivePage({required this.orgId, super.key});

  @override
  State<CreateDonationDrivePage> createState() =>
      _CreateDonationDrivePageState();
}

class _CreateDonationDrivePageState extends State<CreateDonationDrivePage> {
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  String _driveName = "";
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Donate'),
        ),
        drawer: const DrawerWidget(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // add upload image form later
                  _driveNameFormField,
                  _descriptionFormField,
                  Row(
                    children: [_startDateFormField, _endDateFormField],
                  ),
                  _submitButton
                ],
              ),
            ),
          ),
        ));
  }

  Widget get _submitButton => ElevatedButton(
      onPressed: () async {
        print("Pressed submit button");
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          DonationDrive newDonationDrive = DonationDrive(
              description: _description,
              driveName: _driveName,
              startDate: _startDate,
              endDate: _endDate,
              status: 0);

          print(newDonationDrive);
          // add donation drive to firebase and also add to organization
          await context
              .read<DonationDriveProvider>()
              .addDrive(newDonationDrive, widget.orgId);
          if (mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: const Text("Finish Editing"));

  Future<void> _selectDate(
      BuildContext context, DateTime date, bool isStart) async {
    // https://stackoverflow.com/questions/56613875/datetime-comparison-in-dart
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null &&
        (picked.isAfter(DateTime.now()) || picked == DateTime.now())) {
      if (isStart) {
        _startDate = picked;
      } else {
        picked.isAfter(_startDate) ? _endDate = picked : DateTime.now();
      }
    }
  }

  Widget get _endDateFormField => Expanded(
      flex: 1,
      child: ListTile(
        leading: const Text("End:"),
        title: TextFormField(
          initialValue: DateFormat('yyyy-MM-dd').format(_endDate),
          onTap: () => _selectDate(context, _endDate, false),
        ),
      ));

  Widget get _startDateFormField => Expanded(
      flex: 1,
      child: ListTile(
        leading: const Text("Start:"),
        title: TextFormField(
          initialValue: DateFormat('yyyy-MM-dd').format(_startDate),
          onTap: () => _selectDate(context, _startDate, true),
        ),
      ));

  Widget get _descriptionFormField => Wrap(
        children: [
          TextFormField(
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(labelText: "Description"),
            initialValue: "widget.drive.description",
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

  Widget get _driveNameFormField => TextFormField(
        decoration: const InputDecoration(labelText: "Drive Name"),
        initialValue: "widget.drive.driveName",
        validator: (value) {
          RegExp reg = RegExp(r"^[\w\s ,.]+$");
          if (value == null || value.isEmpty) {
            return "Address field must contain something";
          } else if (value.length >= 30) {
            return "Drive Name should contain no less than 30 characters";
          } else if (!reg.hasMatch(value)) {
            return "Please input a valid address";
          } else {
            setState(() {
              _driveName = value;
            });
          }
          return null;
        },
      );
}
