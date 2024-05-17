import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/route_manager.dart';
import 'package:trunriproject/home/bottom_bar.dart';
import 'package:trunriproject/signUpScreen.dart';
import 'package:trunriproject/widgets/appTheme.dart';

import '../widgets/customTextFormField.dart';
import '../widgets/helper.dart';
import 'firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.fromLogin, this.home});
  final bool? fromLogin;
  final bool? home;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFireStoreService fireStoreService = FirebaseFireStoreService();
  bool isobscurepassword = true;
  File image = File("");

  updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    try {

      await fireStoreService.updateProfile(
        address: address.text.trim(),
        allowChange: image.path.isEmpty ? false : imagePicked,
        context: context,
        email: email.text.trim(),
        name: nameController.text.trim(),
        profileImage: image,
        updated: (bool value) {
          if (value) {
            if (widget.fromLogin == false) {
              Get.back();
            } else {
              Get.offAll(const MyBottomNavBar());
            }
          } else {
            showToast("Failed to update profile");
          }
        },
      );
    } catch (e) {
      showToast("Error updating profile: $e");
      print("Error updating profile: $e");
    }
  }

  bool imagePicked = false;
  bool dataLoaded = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController address = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (fireStoreService.userLoggedIn) {
      dataLoaded = false;
      fireStoreService.getProfileDetails().then((value) {
        if (value == null) {
          dataLoaded = true;
          setState(() {});
          return;
        }
        nameController.text = value.name.toString();
        email.text = value.email.toString();
        address.text = value.address.toString();
        image = File(value.profile.toString());
        dataLoaded = true;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.home == null
          ? AppBar(
        title: const Text('Profile'),
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: const Icon(Icons.arrow_back_ios)),
      )
          : null,
      body: dataLoaded
          ? Container(
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
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      NewHelper.showImagePickerSheet(
                          gotImage: (File gg) {
                            image = gg;
                            imagePicked = true;
                            setState(() {});
                          },
                          context: context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                              )
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10000),
                            child: Image.file(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.network(
                                image.path,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  CupertinoIcons.person_alt_circle,
                                  size: 45,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Colors.white,
                                ),
                                color: Colors.blue),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CommonTextField(
                    hintText: 'Full Name',
                    controller: nameController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'email is required'),
                    ]).call),
                CommonTextField(
                    hintText: 'Email',
                    controller: email,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'email is required'),
                      EmailValidator(errorText: 'Please enter valid email'),
                    ]).call),
                CommonTextField(
                    hintText: 'Address',
                    controller: address,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Address is required'),
                    ]).call),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Get.offAll(const SignUpScreen());
                          showToast("Logged Out Successfully");
                        });
                      },
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateProfile();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.mainColor,
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                if (FirebaseAuth.instance.currentUser != null)
                  ElevatedButton(
                    onPressed: () async {
                      User? user = FirebaseAuth.instance.currentUser;
                      await user!.delete();
                      showToast("Your account has been deleted");
                      Get.to(const SignUpScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }


}
