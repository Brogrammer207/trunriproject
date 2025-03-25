import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../multiImageWidget.dart';
import '../widgets/appTheme.dart';
import '../widgets/customTextFormField.dart';
import '../widgets/helper.dart';
import 'eventHomeScreen.dart';

class PostEventScreen extends StatefulWidget {
  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen> {

  TextEditingController eventNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ticketPriceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactInformationController = TextEditingController();
  Rx<File> profileImage = Rx<File>(File(''));
  List<File> selectedFiles = [];
  String? selectedDate;
  String? selectedTime;
  var borderColor = Color(0xff99B2C6).obs;
  List<String> selectedCategories = [];
  List<String> selectedEventTypes = [];
  Future<void> pickImage() async {
    print("message");
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        profileImage.value = File(pickedFile.path);
        borderColor.value = Color(0xff99B2C6);
      });
    } else {
      showToast("No image selected");
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked.format(context);
      });
    }
  }

  void submitEvent() async {
    if (selectedFiles.isEmpty) {
      showToast('Please upload at least one image');
      return;
    }

    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);

    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = [];
      for (var file in selectedFiles) {
        String fileName = 'events/${DateTime.now().millisecondsSinceEpoch}.jpg';
        var ref = FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Send data to Firestore
      await FirebaseFirestore.instance.collection('MakeEvent').doc().set({
        'eventName': eventNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategories,  // Should be a List<String>
        'ticketPrice': ticketPriceController.text.trim(),
        'eventType': selectedEventTypes, // Should be a List<String>
        'eventDate': selectedDate,
        'eventTime': selectedTime,
        'location': locationController.text.trim(),
        'contactInformation': contactInformationController.text.trim(),
        'photo': imageUrls,  // Sending multiple images
      }).then((value){
        Get.to(EventDiscoveryScreen());
      });

      NewHelper.hideLoader(loader);
      showToast('Event submitted successfully');
    } catch (e) {
      NewHelper.hideLoader(loader);
      showToast('Error submitting event: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
          title: const Text('Post Your Event')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              SizedBox(height: 10,),
            CommonTextField(
              controller: eventNameController,
            hintText: 'Event Name',
            // controller: passwordController,
            keyboardType: TextInputType.text,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Event Name is required'),
            ]).call,
          ),
              CommonTextField(
                controller: descriptionController,
                hintText: 'Description',
                // controller: passwordController,
                keyboardType: TextInputType.text,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Description is required'),
                ]).call,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25,top: 8.0,bottom: 8),
                child: DropdownButtonFormField(
                  items: ['Music', 'Traditional', 'Business', 'Community & Culture', 'Health & Fitness', 'Fashion']
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    selectedCategories.add(value!);
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterStyle:
                    GoogleFonts.roboto(color: AppTheme.secondaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                    counter: const Offstage(),
                    errorMaxLines: 2,
                    labelStyle: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                    hintStyle: GoogleFonts.urbanist(
                        color: const Color(0xFF86888A), fontSize: 13, fontWeight: FontWeight.w400),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(15)),
                    hintText: "Select Category"
                  ),
                ),
              ),
              CommonTextField(
                controller: ticketPriceController,
                hintText: 'Ticket Price',
                // controller: passwordController,
                keyboardType: TextInputType.number,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Ticket Price is required'),
                ]).call,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25,top: 8.0,bottom: 8),
                child: DropdownButtonFormField(
                  items: ['Online', 'Offline', 'Free', 'Paid']
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) {
                    selectedEventTypes.add(value!);
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      counterStyle:
                      GoogleFonts.roboto(color: AppTheme.secondaryColor, fontSize: 15, fontWeight: FontWeight.w400),
                      counter: const Offstage(),
                      errorMaxLines: 2,
                      labelStyle: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                      hintStyle: GoogleFonts.urbanist(
                          color: const Color(0xFF86888A), fontSize: 13, fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(15)),
                      hintText: "Event Type"
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CommonTextField(
                    hintText: selectedDate ?? 'Event Date',
                    keyboardType: TextInputType.text,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Event Date is required'),
                    ]).call,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: CommonTextField(
                    hintText: selectedTime ?? 'Event Time',
                    keyboardType: TextInputType.text,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Event Time is required'),
                    ]).call,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25),
                child: MultiImageWidget(
                  files: selectedFiles,
                  title: 'Upload Business Photos'.tr,
                  validation: true,
                  imageOnly: true,
                  filesPicked: (List<File> pickedFiles) {
                    setState(() {
                      selectedFiles = pickedFiles;
                    });
                  },
                ),
              ),
              CommonTextField(
                controller: locationController,
                hintText: 'Location',
                maxLines: 3,
                minLines: 3,
                // controller: passwordController,
                keyboardType: TextInputType.text,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Location is required'),
                ]).call,
              ),
              CommonTextField(
                controller: contactInformationController,
                hintText: 'Contact Information',
                // controller: passwordController,
                keyboardType: TextInputType.text,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Contact Information is required'),
                ]).call,
              ),
              GestureDetector(
                onTap: () {
                  submitEvent();
                },
                child: Container(
                  margin: EdgeInsets.only(left: 25,right: 25,top: 30,bottom: 10),
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF730A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Publish Event",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
