import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/commomButton.dart';
import '../widgets/imageWidget.dart';
import 'flatmatesScreen.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({super.key});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  List<File> selectedFiles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Step 4: Media',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add some photos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: ImageWidget(
                  files: selectedFiles,
                  validation: true,
                  imageOnly: true,
                  filesPicked: (List<File> pickedFiles) {
                    setState(() {
                      selectedFiles = pickedFiles;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Give your listing a title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'No deposit room in Tooley Street',
                  hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w300)
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add a description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'No deposit room in Tooley Street',
                    hintStyle: TextStyle(fontSize: 15,fontWeight: FontWeight.w300)
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(15.0).copyWith(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: CommonButton(
                    text: 'Continue',
                    color: const Color(0xffFF730A),
                    textColor: Colors.white,
                    onPressed: () {
                      Get.to(const FlatmateScreen());
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
