import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agri_market/splashscreen.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import 'package:agri_market/firestore_helper.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    FirestoreHelper.initializeLogging();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    Logger.root.severe('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Agri-Market',
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: const Color.fromARGB(255, 49, 137, 52),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 49, 137, 52),
            onPrimary: Colors.white,
            onSecondary: const Color.fromARGB(255, 218, 255, 220),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color.fromARGB(255, 54, 140, 57),
          ),
          fontFamily: 'Poppins',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}