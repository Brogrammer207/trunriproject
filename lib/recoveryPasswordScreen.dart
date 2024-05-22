import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:trunriproject/signinscreen.dart';
import 'package:trunriproject/widgets/customTextFormField.dart';
import 'package:trunriproject/widgets/helper.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  void checkEmailInFirestore(BuildContext context) async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);

    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('User').where('email', isEqualTo: emailController.text).get();

    if (result.docs.isNotEmpty) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((value) {
        Get.to(const SignInScreen());
        showToast('Reset Password link is sent to your Email');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email not found in database"),
      ));
    }

    NewHelper.hideLoader(loader);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),

        child: SafeArea(
            child: ListView(
          children: [
            Lottie.asset("assets/loti/lock.json", height: 300),
            const Text(
              "Forget Your Password ?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35, color: Colors.black, height: 1.2),
            ),
            SizedBox(height: size.height * 0.04),
            const Text(
              "Enter your email address and we'll send you instructions on how to reset your password.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.2),
            ),
            SizedBox(height: size.height * 0.04),
            CommonTextField(
              hintText: 'Email your Email',
              controller: emailController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'email is required'),
                EmailValidator(errorText: 'Please enter valid email'.tr),
              ]).call,
              onEditingCompleted: () {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: size.height * 0.07),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // for sign in button
                  GestureDetector(
                    onTap: () {
                      checkEmailInFirestore(context);
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
                          "Send",
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
          ],
        )),
      ),
    ));
  }
}
