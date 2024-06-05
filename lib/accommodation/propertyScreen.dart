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
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Property size',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffix: Text('m2'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Is there a lift ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('Yes')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('No')],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'How many bedrooms?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text('Single Bedrooms'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Text('Double Bedrooms'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'How many bathrooms?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text('Bathrooms'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Text('Toilets'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'How lives in the property?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text('Female'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Text('Male'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                children: [
                  Text('Non-Binary'),
                  Spacer(),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('0'),
                  SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    maxRadius: 15,
                    minRadius: 15,
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'What the size of the room?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  suffix: Text('m2'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Is it exterior or interior?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Select exterior if your room faces the street or interior if it faces the buildings interior patio',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Checkbox(value: false, onChanged: (value) {}), const Text('Interior')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Checkbox(value: false, onChanged: (value) {}), const Text('Exterior')],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Does the room have bed ?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('Yes')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Radio(value: true, groupValue: 'yes', onChanged: (value) {}), const Text('No')],
              ),
              const SizedBox(
                height: 20,
              ),
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
