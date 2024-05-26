import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../widgets/appTheme.dart';
import '../widgets/customTextFormField.dart';
import '../widgets/imageWidget.dart';

class AddAccommodationScreen extends StatefulWidget {
  const AddAccommodationScreen({super.key});

  @override
  State<AddAccommodationScreen> createState() => _AddAccommodationScreenState();
}

class _AddAccommodationScreenState extends State<AddAccommodationScreen> {
  get emailController => null;
  String roomType = 'Single';
  List<String> roomTypeList = ['Single', 'Double', 'Triple'];
  List<File> selectedFiles = [];
  TextEditingController accommodationNameController = TextEditingController();
  TextEditingController accommodationEmailController = TextEditingController();
  TextEditingController accommodationNumberController = TextEditingController();
  TextEditingController accommodationAddressController = TextEditingController();
  TextEditingController accommodationFacilitiesController = TextEditingController();
  TextEditingController accommodationInformationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Accommodation'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Your Accommodation Name',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            CommonTextField(
                hintText: 'Name',
                controller: accommodationNameController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Name is required'),
                ]).call),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Your Email',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            CommonTextField(
                hintText: 'Email',
                controller: accommodationEmailController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Email is required'),
                ]).call),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Your Contact Number',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            CommonTextField(
                hintText: 'Contact Number',
                controller: accommodationNumberController,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Contact Number is required'),
                ]).call),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Your Accommodation Type',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: DropdownButtonFormField<String>(
                value: roomType,
                onChanged: (String? newValue) {
                  setState(() {
                    roomType = newValue!;
                  });
                },
                items: roomTypeList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: const Color(0xffE2E2E2).withOpacity(.35),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10).copyWith(right: 8),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      borderSide: BorderSide(color: AppTheme.secondaryColor)),
                  errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      borderSide: BorderSide(color: Color(0xffE2E2E2))),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      borderSide: BorderSide(color: AppTheme.secondaryColor)),
                  disabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    borderSide: BorderSide(color: AppTheme.secondaryColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    borderSide: BorderSide(color: Color(0xffE2E2E2).withOpacity(.35)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an item';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Your Address',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            CommonTextField(
                hintText: 'Address',
                controller: accommodationAddressController,
                maxLines: 2,
                minLines: 2,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Address is required'),
                ]).call),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Accommodation facilities',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            CommonTextField(
                hintText: 'Accommodation facilities',
                controller: accommodationFacilitiesController,
                maxLines: 5,
                minLines: 5,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Accommodation facilities is required'),
                ]).call),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'Enter Important Information',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black),
              ),
            ),
            CommonTextField(
                hintText: 'Important Information',
                controller: accommodationInformationController,
                maxLines: 5,
                minLines: 5,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Important Information is required'),
                ]).call),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 25),
              child: ImageWidget(
                files: selectedFiles,
                title: 'Select Images',
                validation: true,
                imageOnly: true,
                filesPicked: (List<File> pickedFiles) {
                  setState(() {
                    selectedFiles = pickedFiles;
                  });
                },
              ),
            ),

            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF730A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
