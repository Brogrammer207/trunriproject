import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/accommodation/whichYouListScreen.dart';

class WhichBestDescribeYouScreen extends StatefulWidget {
  const WhichBestDescribeYouScreen({super.key});

  @override
  State<WhichBestDescribeYouScreen> createState() => _WhichBestDescribeYouScreenState();
}

class _WhichBestDescribeYouScreenState extends State<WhichBestDescribeYouScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SafeArea(

        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              const Text(
                'Which best describe you?',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
              ),
              const Text(
                'This information helps us give you the best experience',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontSize: 15),
              ),
              const Spacer(),
              GestureDetector(
                onTap: (){
                  Get.to(const WhichYouListScreen());
                },
                child: Container(height: 80,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(11)),
                  child: const Center(
                    child:  Text(
                      'I am an individual',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(11)),
                child:  const Center(
                  child:  Text(
                    'I am a real estate agent',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
