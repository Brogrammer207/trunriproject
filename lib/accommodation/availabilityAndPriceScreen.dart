import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/commomButton.dart';
import 'addMediaScreen.dart';

class AvailabilityAndPriceScreen extends StatefulWidget {
  const AvailabilityAndPriceScreen({super.key});

  @override
  State<AvailabilityAndPriceScreen> createState() => _AvailabilityAndPriceScreenState();
}

class _AvailabilityAndPriceScreenState extends State<AvailabilityAndPriceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Step 3: Availability and price',
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
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Set the availability',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 150,
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(25)),
                    child: const Center(child: Text('4 june 2024')),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(25)),
                    child: const Center(child: Text('No Date')),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minimum stay',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(25)),
                        child: const Center(child: Text('1 Month')),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Maximum stay',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 25, right: 25),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(25)),
                        child: const Center(child: Text('No max')),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Whats the monthly rent ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffix: Text('GBP/month'),
                ),
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Bills include',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              SizedBox(height: 20,),
              const Text(
                'And the deposit ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'No deposit required',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(

                ),
              ),
              SizedBox(height: 20,),
              const Text(
                'Any services include in the rent ? optional',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Rental contract',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Cleaning Service',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'City hall registration support',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              Row(
                children: [
                  Checkbox(value: false, onChanged: (value) {}),
                  const Text(
                    'Maintenance service',
                    style: TextStyle(fontSize: 12),
                  )
                ],
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
                      Get.to(const AddMediaScreen());
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
