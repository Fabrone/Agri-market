import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agri_market/services/firebase_service.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart';

class LocationScreen extends StatefulWidget {
  static const String id = 'location-screen';
  final String? popScreen;

  const LocationScreen({super.key, this.popScreen});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final FirebaseService _service = FirebaseService();
  Location location = Location();
  bool _loading = true;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? manualAddress;

  @override
  void initState() {
    super.initState();
    checkAndNavigate();
  }

  Future<void> checkAndNavigate() async {
    try {
      final DocumentSnapshot document = await _service.users.doc(_service.user!.uid).get();

      if (!mounted) return;

      if (document.exists && document['address'] != null) {
        // Use NavigatorKey for navigation
        Navigator.pushReplacementNamed(context, 'main-screen');
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return null;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return null;
    }

    return await location.getLocation();
  }

  Future<void> handleLocationUpdate(LocationData value, ProgressDialog progressDialog) async {
    if (!mounted) return;

    try {
      await _service.updateUser({
        'location': GeoPoint(value.latitude!, value.longitude!),
        'address': manualAddress ?? '',
      }, context, widget.popScreen);

      if (!mounted) return;
      progressDialog.dismiss();

      if (!mounted) return;
      Navigator.pushNamed(context, widget.popScreen.toString());
    } catch (e) {
      if (mounted) {
        progressDialog.dismiss();
      }
    }
  }

  Future<void> updateManualLocation(String? value) async {
    if (!mounted) return;

    if (value != null) {
      setState(() {
        cityValue = value;
        manualAddress = '$cityValue, $stateValue, $countryValue';
      });

      try {
        await _service.updateUser({
          'address': manualAddress,
          'state': stateValue,
          'city': cityValue,
          'country': countryValue,
        }, context, widget.popScreen);
      } catch (e) {
        // Handle error if needed
      }
    }
  }

  Future<void> showBottomScreen() async {
    final locationData = await getLocation();

    if (!mounted) return;

    if (locationData != null) {
      showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (BuildContext bottomSheetContext) {
          return Column(
            children: [
              const SizedBox(height: 26),
              AppBar(
                automaticallyImplyLeading: false,
                iconTheme: const IconThemeData(color: Colors.black),
                elevation: 1,
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(bottomSheetContext),
                      icon: const Icon(Icons.clear),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Location',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SizedBox(
                    height: 40,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Search City, area or neighbourhood',
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () async {
                  final progressDialog = showProgressDialog(bottomSheetContext, 'Fetching location...');
                  final value = await getLocation();

                  if (!mounted) return;

                  if (value != null) {
                    await handleLocationUpdate(value, progressDialog);
                  } else {
                    progressDialog.dismiss();
                  }
                },
                horizontalTitleGap: 0.0,
                leading: const Icon(Icons.my_location, color: Colors.blue),
                title: const Text(
                  'Use current location',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Fetching location...',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 4, top: 4),
                  child: Text(
                    'CHOOSE City',
                    style: TextStyle(color: Colors.blueGrey.shade900, fontSize: 12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: CSCPicker(
                  layout: Layout.vertical,
                  flagState: CountryFlag.DISABLE,
                  dropdownDecoration: const BoxDecoration(shape: BoxShape.rectangle),
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onCityChanged: (value) => updateManualLocation(value),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  ProgressDialog showProgressDialog(BuildContext context, String loadingText) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      loadingText: loadingText,
      progressIndicatorColor: Theme.of(context).primaryColor,
    );
    progressDialog.show();
    return progressDialog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.asset('assets/images/Location.png'),
          const SizedBox(height: 20),
          const Text(
            'Enter Your Delivery Location',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          _loading
              ? const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Finding location...'),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
                              ),
                              icon: const Icon(CupertinoIcons.location_fill),
                              label: const Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Text("Detect Location", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),

                              onPressed: () async {
                                final progressDialog = showProgressDialog(context, 'Fetching location...');
                                
                                // Get the location
                                LocationData? value;
                                try {
                                  value = await getLocation();
                                } catch (e) {
                                  progressDialog.dismiss();
                                  // Handle error if needed
                                  return;
                                }

                                // Check if the widget is still mounted
                                if (!mounted) {
                                  progressDialog.dismiss();
                                  return;
                                }

                                if (value != null) {
                                  // Store necessary data before async call
                                  final address = manualAddress ?? '';
                                  final location = GeoPoint(value.latitude!, value.longitude!);

                                  // Use context safely after confirming mounted
                                  try {
                                    if (context.mounted) {
                                    await _service.updateUser({
                                      'address': address,
                                      'location': location,
                                    }, context, widget.popScreen);}
                                  } catch (e) {
                                    // Handle error if needed
                                  }
                                }

                                // Dismiss the progress dialog only if mounted
                                if (mounted) {
                                  progressDialog.dismiss();
                                }
                              },


                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final progressDialog = showProgressDialog(context, 'Fetching location...');
                        await showBottomScreen();
                        progressDialog.dismiss();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2)),
                          ),
                          child: const Text(
                            "Set Location manually",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
