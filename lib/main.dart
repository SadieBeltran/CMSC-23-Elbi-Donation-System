import 'package:elbi_donation_system/firebase_options.dart';
import 'package:elbi_donation_system/providers/auth_provider.dart';
import 'package:elbi_donation_system/providers/donation_items_provider.dart';
import 'package:elbi_donation_system/providers/donor_provider.dart';
import 'package:elbi_donation_system/providers/org_provider.dart';
import 'package:elbi_donation_system/screens/admin_screens/admin_screen.dart';
import 'package:elbi_donation_system/screens/authentication_screens/sign_in_page.dart';
import 'package:elbi_donation_system/screens/organization_screens/edit_org_profile.dart';
import 'package:elbi_donation_system/screens/organization_screens/org_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
// screens
import 'package:elbi_donation_system/screens/donor_screens/donor_home_page.dart';
import 'package:provider/provider.dart' as provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // change the color of the device's navigation bar to match the background of the app
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(
            create: ((context) => UserAuthProvider())),
        provider.ChangeNotifierProvider(
            create: ((context) => DonorListProvider())),
        provider.ChangeNotifierProvider(
          create: ((context) => OrgListProvider()),
        ),
        provider.ChangeNotifierProvider(
          create: ((context) => DonationItemProvider()),
        )
      ],
      child: const ProviderScope(
        child: ElbiUnity(),
      ),
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
        home: const SignInPage(),
        initialRoute: "/signInPage",
        onGenerateRoute: (settings) {
          if (settings.name == "/donorHome") {
            return MaterialPageRoute(builder: (context) => DonorHomePage());
          }
          if (settings.name == "/adminHome") {
            return MaterialPageRoute(builder: (context) => AdminScreen());
          }
          if (settings.name == "/orgHome") {
            return MaterialPageRoute(builder: (context) => OrgHomePage());
          }
        });
  }
}
