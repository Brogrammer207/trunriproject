import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/bottom_bar.dart';

import '../widgets/appTheme.dart';
import '../widgets/commomButton.dart';

class FlatmateScreen extends StatefulWidget {
  const FlatmateScreen({super.key});

  @override
  State<FlatmateScreen> createState() => _FlatmateScreenState();
}

class _FlatmateScreenState extends State<FlatmateScreen> {
  RangeValues currentRangeValues = const RangeValues(10, 80);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Step 5: Flatmates',
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
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who would you prefer to live in the property ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                'Choose at least one option.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Male',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Female',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Non-binary',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'What the preferred age group?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: const Text(
                  '0 to 15 years old',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ),
              RangeSlider(
                values: currentRangeValues,
                max: 99,
                divisions: 99,
                labels: RangeLabels(
                  currentRangeValues.start.round().toString(),
                  currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {},
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                'And their current situation?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('Working')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('Studying')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('O dont mind')],
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
                      Get.to(const MyBottomNavBar());
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
