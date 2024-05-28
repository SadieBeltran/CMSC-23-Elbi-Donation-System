import 'package:elbi_donation_system/data_models/donation_drive.dart';
import 'package:elbi_donation_system/screens/reusables/drawer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class EditDonationDrivePage extends StatefulWidget {
  final DonationDrive drive;
  const EditDonationDrivePage({required this.drive, super.key});

  @override
  State<EditDonationDrivePage> createState() => EditDonationDrivePageState();
}

class EditDonationDrivePageState extends State<EditDonationDrivePage> {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/org_images/kulto.png',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ), //placeholder image
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _driveNameFormField,
                        _descriptionFormField,
                        Row(
                          children: [_startDateFormField, _endDateFormField],
                        ),
                        _submitButton
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget get _submitButton => ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          setState(() {
            widget.drive.driveName = _driveName;
            widget.drive.description = _description;
            widget.drive.startDate = _startDate;
            widget.drive.endDate = _endDate;
          });
          Navigator.pop(context);
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
        picked.isAfter(_startDate) ? _endDate = picked : null;
      }
    }
  }

  Widget get _endDateFormField => Expanded(
      flex: 1,
      child: ListTile(
        leading: const Text("End:"),
        title: TextFormField(
          initialValue: DateFormat('yyyy-MM-dd').format(widget.drive.endDate),
        ),
        onTap: () => _selectDate(context, widget.drive.endDate, false),
      ));

  Widget get _startDateFormField => Expanded(
      flex: 1,
      child: ListTile(
        leading: const Text("Start:"),
        title: TextFormField(
          initialValue: DateFormat('yyyy-MM-dd').format(widget.drive.startDate),
        ),
        onTap: () => _selectDate(context, widget.drive.startDate, true),
      ));

  Widget get _descriptionFormField => Wrap(
        children: [
          TextFormField(
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(labelText: "Description"),
            initialValue: widget.drive.description,
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
        initialValue: widget.drive.driveName,
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
