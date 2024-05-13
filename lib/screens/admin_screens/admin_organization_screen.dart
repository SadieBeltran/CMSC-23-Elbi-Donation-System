import 'package:flutter/material.dart';
// data model
import 'package:elbi_donation_system/data_models/organization.dart';
// screens
import 'package:elbi_donation_system/screens/donor_screens/donate_screen.dart';

class OrganizationsListViewItem extends StatelessWidget {
  const OrganizationsListViewItem({
    required this.org,
    super.key,
  });

  // properties
  final Organization org;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        // Inkwell makes the content of the card tapable
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => DonateScreen(
                org: org,
              ),
            ),
          );
        },
        splashColor: Colors.black,
        child: Stack(
          children: [
            // Hero() is a built-in flutter widget that allows images to animate
            // to the same image into the next screen
            Hero(
              tag: org.id!,
              child: Image.asset(
                org.orgImagePath,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            // Positioned widget positions a widget on top of another widget in the stack
            Positioned(
              // make the child widget container be positioned in the bottom of the
              // previous widget in the stack, and span left to right
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.organizationName,
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow
                          .ellipsis, // for handling overflow for very long texts
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // const SizedBox(height: ),
                    Text(
                      org.addresses[0],
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow
                          .ellipsis, // for handling overflow for very long texts
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
