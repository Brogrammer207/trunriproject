import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/helper.dart';
import 'locationScreen.dart';

class WhichYouListScreen extends StatefulWidget {
  const WhichYouListScreen({super.key});

  @override
  State<WhichYouListScreen> createState() => _WhichYouListScreenState();
}

class _WhichYouListScreenState extends State<WhichYouListScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveData(String text) async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('accommodation').add({
        'uid': user.uid,
        'roomType': text,
      });
      NewHelper.hideLoader(loader);
      showToast('Selected');
    } else {
      NewHelper.hideLoader(loader);
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.clear)),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              const Text(
                'What do you wish to list ?',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: () async {
                  await saveData('A room');
                  Get.to(const LocationScreen());
                },
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(11)),
                  child: Center(
                    child: Row(
                      children: [
                        Image.asset('assets/images/aroom.png',height: 40,width: 40,),
                        const SizedBox(width: 15,),
                        const Text(
                          'A room',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await saveData('An apartment');
                  Get.to(const LocationScreen());
                },
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Image.asset('assets/images/apartment.png',height: 40,width: 40,),
                        const SizedBox(width: 15,),
                        const Text(
                          'An apartment',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
