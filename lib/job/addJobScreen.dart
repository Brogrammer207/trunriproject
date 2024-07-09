import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:trunriproject/widgets/helper.dart';

import '../widgets/customTextFormField.dart';
import 'jobHomePageScreen.dart';

class AddJobScreen extends StatefulWidget {
  const AddJobScreen({super.key});

  @override
  State<AddJobScreen> createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  TextEditingController positionNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController openingsController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController industryTypeController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController employmentTypeController = TextEditingController();
  TextEditingController roleCategoryController = TextEditingController();
  TextEditingController eductionController = TextEditingController();
  TextEditingController keySkillsController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController aboutCompanyController = TextEditingController();

  final formKey1 = GlobalKey<FormState>();

  String? experience;

  final List<String> experienceOptions = [
    '0-1 years',
    '1-3 years',
    '3-5 years',
    '5+ years'
  ];
  String? employmentType;

  final List<String> employmentTypeOption = [
    'Casual',
    'Temp',
    'Contract',
    'Part time',
    'Full time',
  ];

  String? schedule;

  final List<String> scheduleOption = [
    '8 hour shift',
    '10 hour shift',
    '12 hour shift',
    'shift work',
    'morning shift',
    'day shift',
    'afternoon shift',
    'evening shift',
    'night shift',
    'rotating roster',
    'fixed shift',
    'monday to friday',
    'every weekend',

  ];

  String? timeOfAdd;

  final List<String> timeOfAddOption = [
    '1 to 3 days',
    '3 to 7 days',
    '1 to 2 weeks',
    '2 to 4 weeks',
    'more Then 4 weeks',
  ];

  String? industryType;

  final List<String> industryTypeOption = [
    'Media, Advertising & Online',
    'Transport & Logistics',
    'Manufacturing',
    'Construction, Design & Engineering',
    'Information & Communication Technology (ICT)',
    'Financial & Insurance Services',
    'Real Estate & Property Services',
    'Professional Services',
    'Healthcare & Social Assistance',
    'Education, Training',
  ];
  String salaryType = 'Hourly';
  String minSalary = '0';
  String maxSalary = '100';

  final List<String> salaryTypes = ['Hourly', 'Monthly', 'Weekly'];
  final List<String> minSalaryOptions = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  final List<String> maxSalaryOptions = List.generate(901, (index) => (index + 100).toString());


  void addJobs() {
    FirebaseFirestore.instance.collection('jobs').doc().set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'postDate': DateTime.now(),
      'positionName': positionNameController.text,
      'companyName': companyNameController.text,
      'experience': experience,
      'salary': '$salaryType: \$$minSalary - \$$maxSalary',
      'openings': openingsController.text,
      'role': roleController.text,
      'industryType': industryType,
      'department': departmentController.text,
      'employmentType': employmentType,
      'roleCategory': roleCategoryController.text,
      'eduction': eductionController.text,
      'keySkills': keySkillsController.text,
      'jobDescription': jobDescriptionController.text,
      'aboutCompany': aboutCompanyController.text,
      'timeOfAdd' : timeOfAdd
    }).then((value) {
      showToast('Add Jobs Successfully');
      Get.to(const JobHomePageScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Job'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Position Name'),
              ),
              CommonTextField(
                  hintText: 'Position Name',
                  controller: positionNameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Position Name is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Company Name'),
              ),
              CommonTextField(
                  hintText: 'Company Name',
                  controller: companyNameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Company Name is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Required Work Experience'),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: experience,
                  items: experienceOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      experience = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Work Experience',
                    border: OutlineInputBorder(),
                  ),
                  validator: RequiredValidator(
                      errorText: 'Experience is required'),
                ),
              ),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Schedule'),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: schedule,
                  items: scheduleOption.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      schedule = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'schedule',
                    border: OutlineInputBorder(),
                  ),
                  validator: RequiredValidator(
                      errorText: 'schedule is required'),
                ),
              ),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Salary'),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: salaryType,
                      items: salaryTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          salaryType = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Salary Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: minSalary,
                            items: minSalaryOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                minSalary = newValue!;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Min Salary',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: maxSalary,
                            items: maxSalaryOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                maxSalary = newValue!;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Max Salary',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('How many positions are open ?'),
              ),
              CommonTextField(
                  hintText: '10',
                  controller: openingsController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'How many positions are open is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Role'),
              ),
              CommonTextField(
                  hintText: 'Role',
                  controller: roleController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Role is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Industry Type'),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: industryType,
                  items: industryTypeOption.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: const TextStyle(fontSize: 10),),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      industryType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Industry Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: RequiredValidator(
                      errorText: 'Industry Type'),
                ),
              ),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Department'),
              ),
              CommonTextField(
                  hintText: 'Department',
                  controller: departmentController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Department is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Job Type'),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: employmentType,
                  items: employmentTypeOption.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      employmentType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Job Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: RequiredValidator(
                      errorText: 'Job Type'),
                ),
              ),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Role Category'),
              ),
              CommonTextField(
                  hintText: 'Role Category',
                  controller: roleCategoryController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Role Category is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Education'),
              ),
              CommonTextField(
                  hintText: 'Education',
                  controller: eductionController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Education is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Key Skills'),
              ),
              CommonTextField(
                  hintText: 'Key Skills',
                  controller: keySkillsController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Key Skills is required'),
                  ]).call),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('How long this job will show'),
              ),
              const SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 25,right: 25),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: timeOfAdd,
                      items: timeOfAddOption.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          timeOfAdd = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'How long this add will show',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Job description'),
              ),
              CommonTextField(
                  hintText: 'Job description',
                  controller: jobDescriptionController,
                  minLines: 5,
                  maxLines: 5,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Job description is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('About company'),
              ),
              CommonTextField(
                  hintText: 'About company',
                  controller: aboutCompanyController,
                  maxLines: 5,
                  minLines: 5,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'About company is required'),
                  ]).call),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  if(formKey1.currentState!.validate()){
                    addJobs();
                  }

                },
                child: Container(
                  margin: const EdgeInsets.only(left: 25,right: 25),
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF730A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Add Job",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
