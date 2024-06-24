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
  final List<String> cityList = [
    'Queensland',
    'Victoria',
    'NSW',
    'South Australia',
    'Western Australia',
    'Northern Territory',
    'Tasmania'
  ];
  String? selectedCity;
  int singleBadRoom = 0;
  int doubleBadRoom = 0;
  int bathrooms = 0;
  int toilets = 0;
  int livingFemale = 0;
  int livingMale = 0;
  int livingNonBinary = 0;
  List<String> roomAmenities = [];
  RangeValues currentRangeValues = const RangeValues(10, 80);
  bool male = false;
  bool female = false;
  bool nonBinary = false;
  bool isWorking = false;
  bool isStudying = false;
  bool isDontMind = false;

  bool showGenderError = false;
  bool showSituationError = false;

  bool isLiftAvailable = false;
  String bedroomFacing = '';
  bool isBedInRoom = false;
  bool showError = false;

  bool isFormValid() {
    bool genderSelected = male || female || nonBinary;
    bool situationSelected = isWorking || isStudying || isDontMind;
    return genderSelected && situationSelected;
  }

  void showToast(String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

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

  bool isFormComplete() {
    if (singleBadRoom == 0 &&
        doubleBadRoom == 0 &&
        bathrooms == 0 &&
        toilets == 0 &&
        livingFemale == 0 &&
        livingMale == 0 &&
        livingNonBinary == 0) {
      return false;
    }
    if (bedroomFacing.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
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
                  'City',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedCity,
                  items: cityList.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCity = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Select City',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                Column(
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
                    if (showError && !isLiftAvailable)
                      const Text(
                        'Please specify if there is a lift',
                        style: TextStyle(color: Colors.red),
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
                    if (showError && singleBadRoom == 0 && doubleBadRoom == 0)
                      const Text(
                        'Please add at least one bedroom',
                        style: TextStyle(color: Colors.red),
                      ),
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
                    if (showError && bathrooms == 0 && toilets == 0)
                      const Text(
                        'Please add at least one bathroom or toilet',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Who is currently living in the property?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _buildCounterRow('Females', 'livingFemale', livingFemale),
                    const SizedBox(height: 5),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 5),
                    _buildCounterRow('Males', 'livingMale', livingMale),
                    const SizedBox(height: 5),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    const SizedBox(height: 5),
                    _buildCounterRow('Non-Binary', 'livingNonBinary', livingNonBinary),
                    if (showError && livingFemale == 0 && livingMale == 0 && livingNonBinary == 0)
                      const Text(
                        'Please add at least one person',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bedroom Facing',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile<String>(
                      title: const Text('Interior'),
                      value: 'interior',
                      groupValue: bedroomFacing,
                      onChanged: (value) {
                        setState(() {
                          bedroomFacing = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Exterior'),
                      value: 'exterior',
                      groupValue: bedroomFacing,
                      onChanged: (value) {
                        setState(() {
                          bedroomFacing = value!;
                        });
                      },
                    ),
                    if (showError && bedroomFacing.isEmpty)
                      const Text(
                        'Please select bedroom facing',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Room Amenities',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('Balcony'),
                      selected: roomAmenities.contains('Balcony'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            roomAmenities.add('Balcony');
                          } else {
                            roomAmenities.removeWhere((String name) {
                              return name == 'Balcony';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('Attached Bathroom'),
                      selected: roomAmenities.contains('Attached Bathroom'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            roomAmenities.add('Attached Bathroom');
                          } else {
                            roomAmenities.removeWhere((String name) {
                              return name == 'Attached Bathroom';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('Air Conditioner'),
                      selected: roomAmenities.contains('Air Conditioner'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            roomAmenities.add('Air Conditioner');
                          } else {
                            roomAmenities.removeWhere((String name) {
                              return name == 'Air Conditioner';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Property Amenities',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('Gym'),
                      selected: propertyAmenities.contains('Gym'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            propertyAmenities.add('Gym');
                          } else {
                            propertyAmenities.removeWhere((String name) {
                              return name == 'Gym';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('Security'),
                      selected: propertyAmenities.contains('Security'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            propertyAmenities.add('Security');
                          } else {
                            propertyAmenities.removeWhere((String name) {
                              return name == 'Security';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Home Rules',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('no drinking'),
                      selected: homeRules.contains('no drinking'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            homeRules.add('no drinking');
                          } else {
                            homeRules.removeWhere((String name) {
                              return name == 'no drinking';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    FilterChip(
                      label: const Text('Pets Allowed'),
                      selected: homeRules.contains('Pets Allowed'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            homeRules.add('Pets Allowed');
                          } else {
                            homeRules.removeWhere((String name) {
                              return name == 'Pets Allowed';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Price Range',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    RangeSlider(
                      values: currentRangeValues,
                      min: 0,
                      max: 750,
                      divisions: 20,
                      labels: RangeLabels(
                        '\$${currentRangeValues.start.round()}',
                        '\$${currentRangeValues.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          currentRangeValues = values;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Preferred Gender',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Male'),
                      value: male,
                      onChanged: (value) {
                        setState(() {
                          male = value!;
                          showGenderError = false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Female'),
                      value: female,
                      onChanged: (value) {
                        setState(() {
                          female = value!;
                          showGenderError = false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Non-Binary'),
                      value: nonBinary,
                      onChanged: (value) {
                        setState(() {
                          nonBinary = value!;
                          showGenderError = false;
                        });
                      },
                    ),
                    if (showGenderError)
                      const Text(
                        'Please select at least one gender',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Living Situation',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      title: const Text('Working'),
                      value: isWorking,
                      onChanged: (value) {
                        setState(() {
                          isWorking = value!;
                          showSituationError = false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Studying'),
                      value: isStudying,
                      onChanged: (value) {
                        setState(() {
                          isStudying = value!;
                          showSituationError = false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text('Don\'t Mind'),
                      value: isDontMind,
                      onChanged: (value) {
                        setState(() {
                          isDontMind = value!;
                          showSituationError = false;
                        });
                      },
                    ),
                    if (showSituationError)
                      const Text(
                        'Please select at least one living situation',
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ShowFilterDataScreen(
                              propertyAmenities: propertyAmenities,
                              homeRules: homeRules,
                               bathrooms: bathrooms,
                              bedroomFacing: bedroomFacing,
                              // currentRangeValues: currentRangeValues,
                              // doubleBadRoom: doubleBadRoom,
                              // female: female,
                              // isBedInRoom: isBedInRoom,
                              // isDontMind: isDontMind,
                              // isLiftAvailable: isLiftAvailable,
                              // isStudying: isStudying,
                              // isWorking: isWorking,
                              // livingFemale: livingFemale,
                              // livingMale: livingMale,
                              // livingNonBinary: livingNonBinary,
                              // male: male,
                              // nonBinary: nonBinary,
                              // roomAmenities: roomAmenities,
                              selectedCity: selectedCity,
                              // showGenderError: showGenderError,
                              // showError: showError,
                              // showSituationError: showSituationError,
                              // singleBadRoom: singleBadRoom,
                              // toilets: toilets,
                            ));
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
                            "Click Here To Filter",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
