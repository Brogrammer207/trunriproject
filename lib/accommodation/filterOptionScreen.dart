import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/accommodation/showFilterDataScreen.dart';

class FilterOptionScreen extends StatefulWidget {
  const FilterOptionScreen({super.key});

  @override
  State<FilterOptionScreen> createState() => _FilterOptionScreenState();
}

class _FilterOptionScreenState extends State<FilterOptionScreen> {
  List<String> propertyAmenities = [];
  List<String> homeRules = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Property amenities',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Wrap(
                children: [
                  for (String amenity in [
                    'Gym',
                    'Garden',
                    'Security',
                    'Laundry facilities',
                    'Playground',
                    'Swimming pool'
                  ])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (propertyAmenities.contains(amenity)) {
                            propertyAmenities.remove(amenity);
                          } else {
                            propertyAmenities.add(amenity);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: propertyAmenities.contains(amenity) ? Color(0xffFF730A) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(amenity),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Are there any house rules',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Wrap(
                children: [
                  for (String amenity in [
                    'No smoking',
                    'Night out',
                    'no drinking',
                  ])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (homeRules.contains(amenity)) {
                            homeRules.remove(amenity);
                          } else {
                            homeRules.add(amenity);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: homeRules.contains(amenity) ? Color(0xffFF730A) : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(amenity),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          log(homeRules.toString());
          Get.to(ShowFilterDataScreen(
            homeRules: homeRules,
            propertyAmenities: propertyAmenities,
          ));
        },
        child: Container(
          margin: EdgeInsets.all(15),
          width: size.width,
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xffFF730A),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              "Filter Data",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
