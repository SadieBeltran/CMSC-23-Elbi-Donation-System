import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
// screens
import 'package:elbi_donation_system/screens/donor_screens/donor_home_page.dart';

void main() {
  // change the color of the device's navigation bar to match the background of the app
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    const ProviderScope(
      child: ElbiUnity(),
    ),
  );
}

class ElbiUnity extends StatelessWidget {
  const ElbiUnity({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const DonorHomePage(),
    );
  }
}
