// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBbysyAv7exljOBA30X1F51AZQ4Gfo_DBw',
    appId: '1:540457100143:web:50b962f8e65f831cbcbe9a',
    messagingSenderId: '540457100143',
    projectId: 'agri-market-d5ed6',
    authDomain: 'agri-market-d5ed6.firebaseapp.com',
    databaseURL: 'https://agri-market-d5ed6-default-rtdb.firebaseio.com',
    storageBucket: 'agri-market-d5ed6.firebasestorage.app',
    measurementId: 'G-J3GHXZ4K5Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5Mf2PesAjvWw6oTAU6VgMHcLTgHe6yHc',
    appId: '1:540457100143:android:1a5b06cd5606533dbcbe9a',
    messagingSenderId: '540457100143',
    projectId: 'agri-market-d5ed6',
    databaseURL: 'https://agri-market-d5ed6-default-rtdb.firebaseio.com',
    storageBucket: 'agri-market-d5ed6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSt9oF5UuNHb29fnCf7Nvuv-TfUV3g-K0',
    appId: '1:540457100143:ios:23b6b6bafda5ac3fbcbe9a',
    messagingSenderId: '540457100143',
    projectId: 'agri-market-d5ed6',
    databaseURL: 'https://agri-market-d5ed6-default-rtdb.firebaseio.com',
    storageBucket: 'agri-market-d5ed6.firebasestorage.app',
    iosClientId: '540457100143-ec3nm0thkvbrqkfkg0o26m2tk1ldsbkg.apps.googleusercontent.com',
    iosBundleId: 'com.example.agriMarket',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCSt9oF5UuNHb29fnCf7Nvuv-TfUV3g-K0',
    appId: '1:540457100143:ios:23b6b6bafda5ac3fbcbe9a',
    messagingSenderId: '540457100143',
    projectId: 'agri-market-d5ed6',
    databaseURL: 'https://agri-market-d5ed6-default-rtdb.firebaseio.com',
    storageBucket: 'agri-market-d5ed6.firebasestorage.app',
    iosClientId: '540457100143-ec3nm0thkvbrqkfkg0o26m2tk1ldsbkg.apps.googleusercontent.com',
    iosBundleId: 'com.example.agriMarket',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBbysyAv7exljOBA30X1F51AZQ4Gfo_DBw',
    appId: '1:540457100143:web:3193baa1bc5f649abcbe9a',
    messagingSenderId: '540457100143',
    projectId: 'agri-market-d5ed6',
    authDomain: 'agri-market-d5ed6.firebaseapp.com',
    databaseURL: 'https://agri-market-d5ed6-default-rtdb.firebaseio.com',
    storageBucket: 'agri-market-d5ed6.firebasestorage.app',
    measurementId: 'G-EM1B5C67MV',
  );

}