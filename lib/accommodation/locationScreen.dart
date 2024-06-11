import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/accommodation/propertyScreen.dart';
import 'package:trunriproject/widgets/helper.dart';
import 'package:uuid/uuid.dart';

import '../widgets/appTheme.dart';
import '../widgets/commomButton.dart';

class LocationScreen extends StatefulWidget {
  String ? dateTime;
  LocationScreen({super.key,this.dateTime});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> cityList = ['Sydney','Albury','Armidale','Bathurst','Blue Mountains','Broken Hill'];
  String? selectedCity;

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
        for (var doc in querySnapshot.docs) {
          await _firestore
              .collection('accommodation')
              .doc(doc.id)
              .update({
            'city': selectedCity,
            'address': addressController.text,
            'floor': floorController.text,
          });
        }
        Get.to(PropertyScreen(dateTime: widget.dateTime,));
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'City',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
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
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Full Address',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                    hintText: 'Eg. : Laxmi nagar', hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Stair,floor and door',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: floorController,
                decoration: const InputDecoration(
                    hintText: 'Eg. : floor no 2', hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
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
                      saveLocationData();

                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
