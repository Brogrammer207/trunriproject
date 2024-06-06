import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/accommodation/propertyScreen.dart';
import 'package:trunriproject/widgets/helper.dart';

import '../widgets/appTheme.dart';
import '../widgets/commomButton.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController floorController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveLocationData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('accommodation')
          .where('uid', isEqualTo: user.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('accommodation')
            .doc(querySnapshot.docs.first.id)
            .update({
          'city': cityController.text,
          'address': addressController.text,
          'floor': floorController.text,
        });
        Get.to(const PropertyScreen());
        showToast('Location saved');
      } else {
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
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                    hintText: 'Eg. : Delhi,jaipur', hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Address',
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