import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:trunriproject/home/bottom_bar.dart';
import 'package:trunriproject/signUpScreen.dart';
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
  bool isEditing = false;

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
      appBar: AppBar(
        title: const Text('Profile'),
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
        actions: [
          GestureDetector(
            onTap: () {
              if (isEditing) {
                updateProfile();
              }
              setState(() {
                isEditing = !isEditing;
              });
            },
            child: isEditing
                ? Image.asset(
                    'assets/images/check.png',
                    height: 30,
                  )
                : Image.asset(
                    'assets/images/edit.png',
                    height: 30,
                  ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: dataLoaded
          ? Container(
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
              padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            GestureDetector(
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
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      // border: InputBorder.none,
                                      hintText: 'Full Name',
                                    ),
                                    readOnly: !isEditing,
                                    controller: nameController,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      // border: InputBorder.none,
                                      hintText: 'Email',
                                    ),
                                    readOnly: !isEditing,
                                    controller: email,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                                  ),
                                  // TextFormField(
                                  //   decoration: const InputDecoration(
                                  //     border: InputBorder.none,
                                  //     hintText: 'Address',
                                  //   ),
                                  //   readOnly: !isEditing,
                                  //   controller: address,
                                  //   maxLines: 3,
                                  //   style:
                                  //       const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/address.png',
                            height: 30,
                          ),
                          title: const Text('Address'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/password.png',
                            height: 30,
                          ),
                          title: const Text('Change Password'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/language.png',
                            height: 30,
                          ),
                          title: const Text('Change Language'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/notification.png',
                            height: 30,
                          ),
                          title: const Text('Notification preferences'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/feedback.png',
                            height: 30,
                          ),
                          title: const Text('Feedback'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/share.png',
                            height: 30,
                          ),
                          title: const Text('Share App'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Image.asset(
                            'assets/images/contact.png',
                            height: 30,
                          ),
                          title: const Text('Contact Us'),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Get.offAll(const SignUpScreen());
                              showToast("Logged Out Successfully");
                            });
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/logout.png',
                              height: 30,
                            ),
                            title: const Text('LogOut'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            User? user = FirebaseAuth.instance.currentUser;
                            await user!.delete();
                            showToast("Your account has been deleted");
                            Get.to(const SignUpScreen());
                          },
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/delete.png',
                              height: 30,
                            ),
                            title: const Text('Delete Account'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
