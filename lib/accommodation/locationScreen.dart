import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trunriproject/accommodation/propertyScreen.dart';
import 'package:trunriproject/widgets/helper.dart';
import 'package:uuid/uuid.dart';

import '../widgets/appTheme.dart';
import '../widgets/commomButton.dart';

class LocationScreen extends StatefulWidget {
  String? dateTime;
  LocationScreen({super.key, this.dateTime});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> stateList = [
    'Queensland',
    'Victoria',
    'NSW',
    'South Australia',
    'Western Australia',
    'Northern Territory',
    'Tasmania'
  ];
  final List<String> cityList = [
    'Victoria',
    'NSW',
    'South Australia',
    'Western Australia',
    'Northern Territory',
    'Tasmania'
  ];

  String? selectedCity;
  String? selectedState;
  final formKey = GlobalKey<FormState>();

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> saveLocationData() async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    User? user = _auth.currentUser;
    log(widget.dateTime.toString());
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('accommodation')
          .where('formID', isEqualTo: widget.dateTime)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Position position = await _getCurrentLocation();
        double latitude = position.latitude;
        double longitude = position.longitude;

        for (var doc in querySnapshot.docs) {
          await _firestore.collection('accommodation').doc(doc.id).update({
            'state': selectedState,
            'city': selectedCity,
            'fullAddress': addressController.text,
            'lat': latitude,
            'long': longitude,
          });
        }
        Get.to(PropertyScreen(dateTime: widget.dateTime));
        NewHelper.hideLoader(loader);
        showToast('Location saved');
      } else {
        NewHelper.hideLoader(loader);
        print('No matching document found');
      }
    } else {
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Step 1: Location',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.clear)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'State',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: selectedState,
                  items: stateList.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedState = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select state',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'State is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'City',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  items: cityList.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select City',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Full Address',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                        hintText:
                        'Ex: H.No/Apartment no, street name, suburb name',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Full Address is required'),
                    ]).call),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(15.0).copyWith(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: 'Continue',
                    color: const Color(0xffFF730A),
                    textColor: Colors.white,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        saveLocationData();
                      }
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
