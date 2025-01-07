import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:agri_market/screens/location_screen.dart'; // Keep this import for navigation

class PhoneAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(BuildContext context, String uid) async {
    final QuerySnapshot result = await users.where('uid', isEqualTo: uid).get();
    List<DocumentSnapshot> document = result.docs;

    if (document.isNotEmpty) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, LocationScreen.id);
      }
    } else {
      await users.doc(uid).set({
        'uid': uid,
        'mobile': auth.currentUser?.phoneNumber,
        'email': auth.currentUser?.email,
        'name': null,
        'address': null,
      }).then((value) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, LocationScreen.id);
        }
      }).catchError((error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add user: $error')));
        }
      });
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number, ProgressDialog progressDialog, Function(String) onCodeSent) async {
    verificationCompleted(PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      if (context.mounted) {
      addUser(context, auth.currentUser!.uid);
      }
    }

    verificationFailed(FirebaseAuthException e) {
      progressDialog.dismiss();
      if (context.mounted) {
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The provided phone number is not valid.')));
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Verification failed: ${e.message}')));
      }
    }

    codeSent(String verId, int? resendToken) {
      progressDialog.dismiss();
      onCodeSent(verId);
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (String verificationId) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auto-retrieval timeout: $verificationId')));
          }
        },
      );
    } catch (e) {
      progressDialog.dismiss();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error during phone verification: ${e.toString()}')));
      }
    }
  }
}
