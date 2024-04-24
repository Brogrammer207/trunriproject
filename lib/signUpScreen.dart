import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:trunriproject/otpScreen.dart';
import 'package:trunriproject/signinscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                const SizedBox(height: 15),
                const Text(
                  "Ready to explore and connect? Let's create your account!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Color(0xff6F6B7A), height: 1.2),
                ),
                SizedBox(height: size.height * 0.04),
                // for username and password
                myTextField("Full Name", Colors.white),
                myTextField("Email", Colors.white),
                myTextField("Phone Number", Colors.white),
                myTextField("Password", Colors.black26),
                myTextField("Confirm Password", Colors.black26),
                const SizedBox(height: 10),

                SizedBox(height: size.height * 0.04),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      // for sign in button
                      GestureDetector(
                        onTap: (){
                          Get.to(const NewOtpScreen());
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
                      SizedBox(height: size.height * 0.06),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          socialIcon("assets/images/google.png",),
                          socialIcon("assets/images/apple.png"),
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
                            children: [ TextSpan(
                              text: "Login now",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    Get.to(const SignInScreen());
                                  }
                            )]
                        ),
                      ),
                      const SizedBox(height: 20,)
                    ],
                  ),
                ),
              ],
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

  Container myTextField(String hint, Color color,) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 5,
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
