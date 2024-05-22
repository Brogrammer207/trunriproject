import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:trunriproject/recoveryPasswordScreen.dart';
import 'package:trunriproject/signUpScreen.dart';
import 'package:trunriproject/widgets/customTextFormField.dart';
import 'package:trunriproject/widgets/helper.dart';

import 'facebook/firebaseservices.dart';
import 'nativAddressScreen.dart';
import 'otpScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool hide = true.obs;
  RxBool hide1 = true.obs;
  EmailOTP myauth = EmailOTP();
  bool showOtpField = false;
  bool value = false;
  bool showValidation = false;
  void SignIn() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
        .then((value) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const NewOtpScreen(),
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
    });
  }

  Future<dynamic> signInWithGoogle(BuildContext context) async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PickUpAddressScreen(),
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

  void checkEmailInFirestore() async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('User').where('email', isEqualTo: emailController.text).get();

    if (result.docs.isNotEmpty) {
      checkPasswordInFirestore();
      NewHelper.hideLoader(loader);
    } else {
      Fluttertoast.showToast(msg: 'Password is incorrect');
      NewHelper.hideLoader(loader);
    }
  }

  void checkPasswordInFirestore() async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('User').where('password', isEqualTo: passwordController.text).get();
    if (result.docs.isNotEmpty) {
      myauth.setConfig(
          appEmail: "contact@hdevcoder.com",
          appName: "TRUNRI",
          userEmail: emailController.text,
          otpLength: 4,
          otpType: OTPType.digitsOnly);
      if (await myauth.sendOTP() == true) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("OTP has been sent"),
        ));

        SignIn();

        NewHelper.hideLoader(loader);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Oops, OTP send failed"),
        ));
      }
      setState(() {
        showOtpField = true;
      });
      return;
    } else {
      Fluttertoast.showToast(msg: 'Password is incorrect');
      NewHelper.hideLoader(loader);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          // const Text(
          //   "Hello Indian!",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 37,
          //     color: Color(0xff353047),
          //   ),
          // ),
          // const SizedBox(height: 15),
          Image.asset(
            "assets/images/hand.gif",
            height: 200.0,
            width: 100.0,
          ),
          const Text(
            "Wellcome back you've\nbeen missed!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 27, color: Color(0xff6F6B7A), height: 1.2),
          ),
          SizedBox(height: size.height * 0.04),
          // for username and password
          CommonTextField(
              hintText: 'Email',
              controller: emailController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Email is required'),
                EmailValidator(errorText: 'Please enter valid email'.tr),
              ]).call),
          Obx(() {
            return CommonTextField(
              hintText: 'Password',
              controller: passwordController,
              keyboardType: TextInputType.text,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Password is required'),
              ]).call,
              obSecure: hide.value,
              suffixIcon: IconButton(
                onPressed: () {
                  hide.value = !hide.value;
                },
                icon: hide.value ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
              ),
            );
          }),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Get.to(const RecoveryPasswordScreen());
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  "Recovery Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff6F6B7A),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.04),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.1,
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: showValidation == false ? Colors.white : Colors.red),
                    child: Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: value,
                        activeColor: Colors.orange,
                        visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
                        onChanged: (newValue) {
                          setState(() {
                            value = newValue!;
                            setState(() {});
                          });
                        }),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Return the dialog box widget
                        return const AlertDialog(
                          title: Text('Terms And Conditions'),
                          content: Text(
                              'Terms and conditions are part of a contract that ensure parties understand their contractual rights and obligations. Parties draft them into a legal contract, also called a legal agreement, in accordance with local, state, and federal contract laws. They set important boundaries that all contract principals must uphold.'
                              'Several contract types utilize terms and conditions. When there is a formal agreement to create with another individual or entity, consider how you would like to structure your deal and negotiate the terms and conditions with the other side before finalizing anything. This strategy will help foster a sense of importance and inclusion on all sides.'),
                          actions: <Widget>[],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const Text('I Accept',
                          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.black)),
                      Text(
                        ' Terms And Conditions?',
                        style: GoogleFonts.poppins(
                            color: const Color(0xffFF730A), fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                // for sign in button
                GestureDetector(
                  onTap: () {
                    if (value == true) {
                      checkEmailInFirestore();
                    } else {
                      showToast('Select Terms And Conditions');
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
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.06),
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
                      onTap: () {
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
                            MaterialPageRoute(builder: (context) => PickUpAddressScreen()),
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
                    GestureDetector(
                        onTap: () async {
                          signInWithFacebook();
                        },
                        child: socialIcon("assets/images/facebook.png")),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Text.rich(
                  TextSpan(
                      text: "Not a member? ",
                      style: const TextStyle(
                        color: Color(0xff6F6B7A),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                            text: "Register now",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
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
      )),
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

  Container myTextField(String hint, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 15,
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.black45,
              fontSize: 19,
            ),
            suffixIcon: Icon(
              Icons.visibility_off_outlined,
              color: color,
            )),
      ),
    );
  }
}
