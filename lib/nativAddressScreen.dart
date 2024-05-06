import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trunriproject/widgets/customTextFormField.dart';
import 'package:trunriproject/widgets/helper.dart';

import 'currentLocation.dart';

class PickUpAddressScreen extends StatefulWidget {
  PickUpAddressScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PickUpAddressScreen> createState() => _PickUpAddressScreenState();
}

class _PickUpAddressScreenState extends State<PickUpAddressScreen> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController zipcodeController = TextEditingController();
  final TextEditingController townController = TextEditingController();
  final TextEditingController specialInstructionController = TextEditingController();
  RxBool hide = true.obs;
  RxBool hide1 = true.obs;
  bool showValidation = false;
  final formKey1 = GlobalKey<FormState>();

  void addNativeAddress(){
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    FirebaseFirestore.instance.collection('nativeAddress').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'Street' : streetController.text.trim(),
      'city': cityController.text.trim(),
      'state' : stateController.text.trim(),
      'country':'India',
      'zipcode':zipcodeController.text.trim(),
      'town':townController.text.trim(),
      'specialInstruction':specialInstructionController.text.trim()
    }).then((value) {
       if(formKey1.currentState!.validate()){
         Get.to(CurrentAddress());
         showToast('Native Address saved Successfully');
         NewHelper.hideLoader(loader);
       }else{
         NewHelper.hideLoader(loader);
       }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Native Address'.tr,
                style: GoogleFonts.poppins(color: Color(0xff292F45), fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            Image.asset(
              "assets/images/location.gif",
              height: 200.0,
              width: 50.0,
            ),
          ],
        ),
      ),
      body: Form(
        key: formKey1,
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              // color: Color(0xFFF2EDE2)
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
                SizedBox(
                  height: size.height * .02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    "Can you tell us where you're from?".tr,
                    style: GoogleFonts.poppins(color: Color(0xff292F45), fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Street'.tr,
                    style:
                        GoogleFonts.poppins(color: const Color(0xff1F1F1F), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                CommonTextField(
                  hintText: 'Ex: shivaji road',
                  controller: streetController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Street is required'),
                  ]).call,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'City'.tr,
                    style:
                        GoogleFonts.poppins(color: const Color(0xff1F1F1F), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                CommonTextField(
                  hintText: 'Ex: Mubai,Delhi, Chennai',
                  controller: cityController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'City is required'),
                  ]).call,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Town'.tr,
                    style:
                        GoogleFonts.poppins(color: const Color(0xff1F1F1F), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                CommonTextField(
                  hintText: 'Town',
                  controller: townController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Town is required'),
                  ]).call,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'State'.tr,
                    style:
                        GoogleFonts.poppins(color: const Color(0xff1F1F1F), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                CommonTextField(
                  hintText: 'Ex: Bihar, Rajasthan, Karnataka',
                  controller: stateController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'State is required'),
                  ]).call,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Country'.tr,
                    style:
                        GoogleFonts.poppins(color: const Color(0xff1F1F1F), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                CommonTextField(
                  hintText: 'India',
                  controller: countryController,
                  readOnly: true,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Image.asset('assets/images/flag.gif',height: 10,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Special Instruction'.tr,
                    style:
                        GoogleFonts.poppins(color: const Color(0xff1F1F1F), fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
                CommonTextField(
                  hintText: 'Special Instruction (Optional)',
                  controller: specialInstructionController,
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                GestureDetector(
                  onTap: () {
                    addNativeAddress();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 25, right: 25),
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF730A),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Confirm Your Address",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

