import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:agri_market/screens/authentication/email_auth_screen.dart';
//import 'package:agri_market/screens/authentication/email_verification_screen.dart';
//import 'package:agri_market/screens/authentication/reset_password_screen.dart';
//import 'package:agri_market/screens/categories/category_list.dart';
//import 'package:agri_market/screens/categories/subCat_screen.dart';
//import 'package:agri_market/screens/home_screen.dart';
//import 'package:agri_market/screens/location_screen.dart';
//import 'package:agri_market/screens/login_screen.dart';
//import 'package:agri_market/screens/authentication/phoneauth_screen.dart';
//import 'package:agri_market/screens/main_screen.dart';
//import 'package:agri_market/screens/playlist_screen.dart';
//import 'package:agri_market/screens/product_details_screen.dart';
//import 'package:agri_market/screens/sellitems/seller_category_list.dart';
//import 'package:agri_market/screens/sellitems/seller_subCat.dart';
//import 'package:agri_market/screens/splash_screen.dart';
//import 'package:agri_market/forms/user_review_screen.dart';
//import 'package:agri_market/forms/forms_screen.dart';
//import 'package:agri_market/forms/tools_form.dart';
//import 'package:agri_market/provider/cat_provider.dart';
//import 'package:agri_market/provider/product_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: const [
        //Provider(create: (_) => CategoryProvider()),
        //Provider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo,
        fontFamily: 'RobotoSlab-Regular',
      ),
      //home: SplashScreen(), // Set the HomeScreen as the initial screen
    );
  }
}
