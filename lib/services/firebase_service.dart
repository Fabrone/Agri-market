
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';

class FirebaseService {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference products = FirebaseFirestore.instance.collection('products');


  Future<void> updateUser(Map<String, dynamic>data, context,screen) {
    return users
        .doc(user!.uid)
        .update(data)
        .then((value) {
      Navigator.pushNamed(context,screen);
    },).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to Update Location'),
        ),);
      //print(error);
    });
  }
  
Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      return "${place.street}, ${place.subLocality}, ${place.locality}";
    } catch (e) {
      return "Unable to fetch address";
    }
}
}