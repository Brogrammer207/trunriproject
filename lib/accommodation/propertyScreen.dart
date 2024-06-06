import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/commomButton.dart';
import 'availabilityAndPriceScreen.dart';


class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  @override
  State<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends State<PropertyScreen> {
  int singleBadRoom = 0;
  int doubleBadRoom = 0;
  int bathrooms = 0;
  int toilets = 0;
  int livingFemale = 0;
  int livingMale = 0;
  int livingNonBinary = 0;

  bool isLiftAvailable = false;
  String bedroomFacing = '';
  bool isBedInRoom = false;

  void _updateCounter(String key, bool increment) {
    setState(() {
      switch (key) {
        case 'singleBadRoom':
          singleBadRoom = increment ? singleBadRoom + 1 : (singleBadRoom > 0 ? singleBadRoom - 1 : 0);
          break;
        case 'doubleBadRoom':
          doubleBadRoom = increment ? doubleBadRoom + 1 : (doubleBadRoom > 0 ? doubleBadRoom - 1 : 0);
          break;
        case 'bathrooms':
          bathrooms = increment ? bathrooms + 1 : (bathrooms > 0 ? bathrooms - 1 : 0);
          break;
        case 'toilets':
          toilets = increment ? toilets + 1 : (toilets > 0 ? toilets - 1 : 0);
          break;
        case 'livingFemale':
          livingFemale = increment ? livingFemale + 1 : (livingFemale > 0 ? livingFemale - 1 : 0);
          break;
        case 'livingMale':
          livingMale = increment ? livingMale + 1 : (livingMale > 0 ? livingMale - 1 : 0);
          break;
        case 'livingNonBinary':
          livingNonBinary = increment ? livingNonBinary + 1 : (livingNonBinary > 0 ? livingNonBinary - 1 : 0);
          break;
      }
    });
  }

  Widget _buildCounterRow(String label, String key, int value) {
    return Row(
      children: [
        Text(label),
        const Spacer(),
        GestureDetector(
          onTap: () => _updateCounter(key, false),
          child: const CircleAvatar(
            maxRadius: 15,
            minRadius: 15,
            child: Icon(Icons.remove),
          ),
        ),
        const SizedBox(width: 10),
        Text('$value'),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _updateCounter(key, true),
          child: const CircleAvatar(
            maxRadius: 15,
            minRadius: 15,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Step 2: Property',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Is there a lift?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isLiftAvailable,
                    onChanged: (value) {
                      setState(() {
                        isLiftAvailable = value!;
                      });
                    },
                  ),
                  const Text('Yes'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: isLiftAvailable,
                    onChanged: (value) {
                      setState(() {
                        isLiftAvailable = value!;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'How many bedrooms?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildCounterRow('Single Bedrooms', 'singleBadRoom', singleBadRoom),
              const SizedBox(height: 5),
              Divider(thickness: 1, color: Colors.grey.shade300),
              const SizedBox(height: 5),
              _buildCounterRow('Double Bedrooms', 'doubleBadRoom', doubleBadRoom),
              const SizedBox(height: 20),
              const Text(
                'How many bathrooms?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildCounterRow('Bathrooms', 'bathrooms', bathrooms),
              const SizedBox(height: 5),
              Divider(thickness: 1, color: Colors.grey.shade300),
              const SizedBox(height: 5),
              _buildCounterRow('Toilets', 'toilets', toilets),
              const SizedBox(height: 20),
              const Text(
                'Who is currently living in the property?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 10),
              _buildCounterRow('Female', 'livingFemale', livingFemale),
              const SizedBox(height: 5),
              Divider(thickness: 1, color: Colors.grey.shade300),
              const SizedBox(height: 5),
              _buildCounterRow('Male', 'livingMale', livingMale),
              const SizedBox(height: 5),
              Divider(thickness: 1, color: Colors.grey.shade300),
              const SizedBox(height: 5),
              _buildCounterRow('Non-Binary', 'livingNonBinary', livingNonBinary),
              const SizedBox(height: 20),
              const Text(
                'What the size of the room?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffix: Text('m2'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Is it exterior or interior?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 5),
              const Text(
                'Select exterior if your room faces the street or interior if it faces the buildings interior patio',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'interior',
                    groupValue: bedroomFacing,
                    onChanged: (value) {
                      setState(() {
                        bedroomFacing = value!;
                      });
                    },
                  ),
                  const Text('Interior'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'exterior',
                    groupValue: bedroomFacing,
                    onChanged: (value) {
                      setState(() {
                        bedroomFacing = value!;
                      });
                    },
                  ),
                  const Text('Exterior'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Is there a bed in the room?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isBedInRoom,
                    onChanged: (value) {
                      setState(() {
                        isBedInRoom = value!;
                      });
                    },
                  ),
                  const Text('Yes'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: false,
                    groupValue: isBedInRoom,
                    onChanged: (value) {
                      setState(() {
                        isBedInRoom = value!;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Room amenities',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Property amenities',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Are there any house rules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40, // Adjust the width and height to match the radius of the CircleAvatar
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                    child: const Icon(Icons.shopping_bag),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              )
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
                      Get.to(const AvailabilityAndPriceScreen());
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
