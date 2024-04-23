import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';


class NewOtpScreen extends StatefulWidget {
  static String route = "/OtpScreen";

  const NewOtpScreen({Key? key}) : super(key: key);

  @override
  State<NewOtpScreen> createState() => _NewOtpScreenState();
}

class _NewOtpScreenState extends State<NewOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  RxInt timerInt = 30.obs;
  Timer? timer;

  setTimer() {
    timerInt.value = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timerInt.value--;
      if (timerInt.value == 0) {
        timer.cancel();
      }
    });
  }

  final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 4.0,
              ))));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setTimer();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF9933),
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(children: [
              Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(color: Color(0xffFF9933)),
                padding: EdgeInsets.symmetric(horizontal: size.width * .02, vertical: size.height * .06),
                child: Column(
                  children: [
                    Image.asset(height: size.height * .15, 'assets/images/otplogo.png'),
                    const SizedBox(
                      height: 13,
                    ),
                    Text(
                      'OTP Verification',
                      style: GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Enter the OTP Send to Your Email',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: size.height * .40,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(100))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
                      child: Column(
                        children: [
                          Pinput(
                            controller: _otpController,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            keyboardType: TextInputType.number,
                            length: 4,
                            defaultPinTheme: defaultPinTheme,
                          ),
                          SizedBox(
                            height: size.height * .05,
                          ),
                          Text(
                            'Didnt you receive the OTP?',
                            style: GoogleFonts.poppins(color: const Color(0xff3D4260), fontSize: 17),
                          ),
                          SizedBox(
                            height: size.height * .03,
                          ),
                          GestureDetector(
                            onTap: () async {
                            },
                            child: Obx(() {
                              return Text(
                                ' Resend OTP\n'
                                    '${timerInt.value > 0 ? "In ${timerInt.value > 9 ? timerInt.value : "0${timerInt.value}"}" : ""}',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600, color: const Color(0xff578AE8), fontSize: 16),
                              );
                            }),
                          ),
                          SizedBox(
                            height: size.height * .2,
                          ),
                        ],
                      ),
                    ),
                  ))
            ])),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15.0).copyWith(bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF9933),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
                textStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Verify OTP'.tr,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
