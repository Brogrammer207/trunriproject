import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trunriproject/widgets/customTextFormField.dart';

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Native Address'.tr,
                style: GoogleFonts.poppins(color: Color(0xff292F45), fontWeight: FontWeight.w600, fontSize: 20),
              ),
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
                    "Where are your hometown".tr,
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
                  hintText: 'Street',
                  controller: streetController,
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
                  hintText: 'City',
                  controller: streetController,
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
                  controller: streetController,
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
                  hintText: 'State',
                  controller: streetController,
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
                  hintText: 'Country',
                  controller: streetController,
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
                  hintText: 'Special Instruction',
                  controller: streetController,
                ),


                SizedBox(
                  height: size.height * .02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(CurrentAddress());
                    if (formKey1.currentState!.validate()) {

                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 25,right: 25),
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

List<Widget> commonField({
  required TextEditingController textController,
  required String title,
  required String hintText,
  required FormFieldValidator<String>? validator,
  required TextInputType keyboardType,
}) {
  return [
    const SizedBox(
      height: 5,
    ),
    Text(
      title.tr,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16, color: const Color(0xff0D5877)),
    ),
    const SizedBox(
      height: 8,
    ),
    CommonTextField(
      controller: textController,
      obSecure: false,
      hintText: hintText.tr,
      validator: validator,
      keyboardType: keyboardType,
    ),
  ];
}
