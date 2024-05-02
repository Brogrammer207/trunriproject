import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trunriproject/homepage.dart';
import 'package:trunriproject/widgets/helper.dart';

class VisaTypeScreen extends StatefulWidget {
  const VisaTypeScreen({super.key});

  @override
  State<VisaTypeScreen> createState() => _VisaTypeScreenState();
}

class _VisaTypeScreenState extends State<VisaTypeScreen> {
  int? selectedVisaType;


  void visaType(){
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    FirebaseFirestore.instance.collection('visaType').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'visaType': selectedVisaType
    }).then((value) {
      if(selectedVisaType != null){
        Get.to(const HomePageScreen());
        showToast('Visa Type Added Successfully');
        NewHelper.hideLoader(loader);
      }else{
        showToast('please select visa Type');
        NewHelper.hideLoader(loader);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Visa Type'.tr,
                style: GoogleFonts.poppins(color: const Color(0xff292F45), fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: Get.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xffF4EEF2),
              Color(0xffF4EEF2),
              Color(0xffE3EDF5),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildRadioButton(1, 'Work visa'),
            buildRadioButton(2, 'Tourist visa'),
            buildRadioButton(3, 'Temporary resident'),
            buildRadioButton(4, 'Permanent resident'),
            Spacer(),
            GestureDetector(
              onTap: (){
                visaType();
              },
              child: Container(
                width: size.width,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xffFF730A),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }

  Widget buildRadioButton(int value, String label) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: selectedVisaType,
          onChanged: (newValue) {
            setState(() {
              selectedVisaType = newValue as int?;
            });
          },
        ),
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.black),
        )
      ],
    );
  }
}
