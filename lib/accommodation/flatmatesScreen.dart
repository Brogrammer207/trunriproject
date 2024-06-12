import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/bottom_bar.dart';

import '../widgets/commomButton.dart';
import '../widgets/helper.dart';

class FlatmateScreen extends StatefulWidget {
  String? dateTime;
  FlatmateScreen({super.key, this.dateTime});

  @override
  State<FlatmateScreen> createState() => _FlatmateScreenState();
}

class _FlatmateScreenState extends State<FlatmateScreen> {
  RangeValues currentRangeValues = const RangeValues(10, 80);
  bool male = false;
  bool female = false;
  bool nonBinary = false;
  bool isWorking = false;
  bool isStudying = false;
  bool isDontMind = false;
  RangeValues _currentRangeValues = const RangeValues(0, 100);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool showGenderError = false;
  bool showSituationError = false;

  bool isFormValid() {
    bool genderSelected = male || female || nonBinary;
    bool situationSelected = isWorking || isStudying || isDontMind;
    return genderSelected && situationSelected;
  }

  Future<void> saveFlatmatesData() async {
    if (!isFormValid()) {
      setState(() {
        showGenderError = !(male || female || nonBinary);
        showSituationError = !(isWorking || isStudying || isDontMind);
      });
      showToast('Please fill in all required fields');
      return;
    }

    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('accommodation')
          .where('formID', isEqualTo: widget.dateTime)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await _firestore.collection('accommodation').doc(doc.id).update({
            'male': male,
            'female': female,
            'nonBinary': nonBinary,
            'isWorking': isWorking,
            'isStudying': isStudying,
            'isDontMind': isDontMind,
            'currentRangeValues': {
              'start': _currentRangeValues.start,
              'end': _currentRangeValues.end,
            },
          });
        }
        Get.to(const MyBottomNavBar());
        NewHelper.hideLoader(loader);
        showToast('Flatmate preferences saved');
      } else {
        NewHelper.hideLoader(loader);
        print('No matching document found');
      }
    } else {
      print('No user logged in');
    }
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
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Who would you prefer to live in the property?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose at least one option.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              Row(
                children: [
                  Checkbox(
                    value: male,
                    onChanged: (value) {
                      setState(() {
                        male = value ?? false;
                        showGenderError = false;
                      });
                    },
                  ),
                  const Text(
                    'Male',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: female,
                    onChanged: (value) {
                      setState(() {
                        female = value ?? false;
                        showGenderError = false;
                      });
                    },
                  ),
                  const Text(
                    'Female',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: nonBinary,
                    onChanged: (value) {
                      setState(() {
                        nonBinary = value ?? false;
                        showGenderError = false;
                      });
                    },
                  ),
                  const Text(
                    'Non-binary',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              if (showGenderError)
                const Text(
                  'Please select at least one gender',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              const Text(
                'What is the preferred age group?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${_currentRangeValues.start.round()} to ${_currentRangeValues.end.round()} years old',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 100,
                divisions: 100,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'And their current situation?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isWorking,
                    onChanged: (value) {
                      setState(() {
                        isWorking = value!;
                        isStudying = false;
                        isDontMind = false;
                        showSituationError = false;
                      });
                    },
                  ),
                  const Text('Working'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isStudying,
                    onChanged: (value) {
                      setState(() {
                        isStudying = value!;
                        isWorking = false;
                        isDontMind = false;
                        showSituationError = false;
                      });
                    },
                  ),
                  const Text('Studying'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: isDontMind,
                    onChanged: (value) {
                      setState(() {
                        isDontMind = value!;
                        isWorking = false;
                        isStudying = false;
                        showSituationError = false;
                      });
                    },
                  ),
                  const Text('I don\'t mind'),
                ],
              ),
              if (showSituationError)
                const Text(
                  'Please select at least one situation',
                  style: TextStyle(color: Colors.red),
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
                    if (isFormValid()) {
                      saveFlatmatesData();
                    } else {
                      setState(() {
                        showGenderError = !(male || female || nonBinary);
                        showSituationError = !(isWorking || isStudying || isDontMind);
                      });
                      showToast('Please fill in all required fields');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
