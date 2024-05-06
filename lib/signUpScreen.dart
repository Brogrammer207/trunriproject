import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:trunriproject/otpScreen.dart';
import 'package:trunriproject/signinscreen.dart';
import 'package:trunriproject/widgets/appTheme.dart';
import 'package:trunriproject/widgets/customTextFormField.dart';
import 'package:trunriproject/widgets/helper.dart';

import 'homepage.dart';

class SignUpScreen extends StatefulWidget{
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  RxBool hide = true.obs;
  RxBool hide1 = true.obs;
  String code = "+91";

  void checkEmailInFirestore() async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: emailController.text)
        .get();

    if (result.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email already in use"),
      ));
    } else {
     register();
    }

    NewHelper.hideLoader(loader);
  }

  void register() {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
        .then((value) {
          FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser!.uid).set({
            'name' : nameController.text.trim(),
            'email' : emailController.text.trim(),
            'phoneNumber' : phoneController.text.trim(),
            'password' : passwordController.text.trim(),
            'confirmPassword' : confirmPasswordController.text.trim()
          }).then((value) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                const SignInScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
            NewHelper.hideLoader(loader);
            showToast('User registered successfully');
          });

    });
  }
  Future<dynamic> signInWithGoogle(BuildContext context) async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const HomePageScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
      NewHelper.hideLoader(loader);

      return userCredential;
    } on Exception catch (e) {
      // Handle the exception
      print('exception->$e');
    }
  }

  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
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
        child: SafeArea(
            child: Form(
              key: formKey1,
              child: ListView(
                children: [
                  SizedBox(height: size.height * 0.03),
                  const Text(
                    "Join the Community!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xff353047),
                    ),
                  ),
                  Image.asset(
                    "assets/images/person.gif",
                    height: 200.0,
                    width: Get.width,
                    fit: BoxFit.fitWidth,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    child: Text(
                      "Ready to explore and connect? Let's create your account!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Color(0xff6F6B7A), height: 1.2),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  // for username and password
                  CommonTextField(
                      hintText: 'Full Name',
                      controller: nameController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Full Name is required'.tr),
                      ]).call

                  ),
                  CommonTextField(
                      hintText: 'Email',
                      controller: emailController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'email is required'),
                        EmailValidator(errorText: 'Please enter valid Referral email'.tr),
                      ]).call
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25,right: 25),
                    child: IntlPhoneField(
                      key: ValueKey(code),
                      flagsButtonPadding: const EdgeInsets.all(8),
                      dropdownIconPosition: IconPosition.trailing,
                      showDropdownIcon: true,
                      cursorColor: Colors.black,
                      textInputAction: TextInputAction.next,
                      dropdownTextStyle: const TextStyle(color: Colors.black),
                      style: const TextStyle(
                          color: AppTheme.textColor
                      ),
                      controller: phoneController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          hintStyle: const TextStyle(
                            color: Colors.black45,
                            fontSize: 19,
                            fontWeight: FontWeight.w400
                          ),
                          hintText: 'Phone Number',
                          labelStyle: TextStyle(color: AppTheme.textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(11),)),
                      initialCountryCode: code.toString(),
                      languageCode: '+91',
                      onCountryChanged: (phone) {
                        code = phone.code;
                        print(phone.code);
                        print(code.toString());
                      },
                      validator: (value) {
                        if (value == null || code.isEmpty) {
                          return 'Please Enter Phone Number'.tr;
                        }
                        return null;
                      },
                      onChanged: (phone) {
                        code = phone.countryISOCode.toString();
                        print(phone.countryCode);
                        print(code.toString());
                      },
                    ),
                  ),
                  // CommonTextField(
                  //     hintText: 'Phone Number',
                  //     controller: phoneController,
                  //     keyboardType: TextInputType.number,
                  //     validator: MultiValidator([
                  //       RequiredValidator(errorText: 'Phone Number is required'),
                  //     ]).call
                  // ),
                  Obx(() {
                    return CommonTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      obSecure: hide.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          hide.value = !hide.value;
                        },
                        icon: hide.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Please enter your password'.tr),
                        MinLengthValidator(8,
                            errorText: 'Password must be at least 8 characters, with 1 special character & 1 numerical'
                                .tr),
                        // MaxLengthValidator(16, errorText: "Password maximum length is 16"),
                        PatternValidator(r"(?=.*\W)(?=.*?[#?!@()$%^&*-_])(?=.*[0-9])",
                            errorText: "Password must be at least 8 characters, with 1 special character & 1 numerical"
                                .tr),
                      ]).call,
                    );
                  }),
                  Obx(() {
                    return CommonTextField(
                      hintText: 'Confirm Password',
                      controller: confirmPasswordController,
                      obSecure: hide1.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          hide1.value = !hide1.value;
                        },
                        icon: hide1.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please enter confirm password';
                        }
                        if (value.trim() != passwordController.text.trim()) {
                          return 'Confirm password is not matching';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 10),

                  SizedBox(height: size.height * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        // for sign in button
                        GestureDetector(
                          onTap: () {
                            if (formKey1.currentState!.validate()) {
                              checkEmailInFirestore();
                            }
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
                                "Sign Up",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 2,
                              width: size.width * 0.2,
                              color: Colors.black12,
                            ),
                            const Text(
                              "  Or continue with   ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6F6B7A),
                                fontSize: 16,
                              ),
                            ),
                            Container(
                              height: 2,
                              width: size.width * 0.2,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                signInWithGoogle(context);
                              },
                              child: socialIcon(
                                "assets/images/google.png",
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final credential = await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
                                  );
                                  final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
                                  final OAuthCredential oAuthCredential = oAuthProvider.credential(
                                    idToken: credential.identityToken,
                                    accessToken: credential.authorizationCode,
                                  );
                                  await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePageScreen()),
                                  );
                                } catch (error) {
                                  print('Error signing in with Apple: $error');
                                }
                              },
                              child: socialIcon("assets/images/apple.png"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            socialIcon("assets/images/facebook.png"),
                          ],
                        ),
                        SizedBox(height: size.height * 0.07),
                        Text.rich(
                          TextSpan(
                              text: "Already have an account ? ",
                              style: const TextStyle(
                                color: Color(0xff6F6B7A),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                    text: "Login now",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                            const SignInScreen(),
                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                              const begin = Offset(1.0, 0.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;
                                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                              var offsetAnimation = animation.drive(tween);
                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      })
                              ]),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Image.asset(
        image,
        height: 35,
      ),
    );
  }
}
