import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:trunriproject/job/showFilterJobsScreen.dart';

import '../widgets/customTextFormField.dart';

class JobFilterOptionScreen extends StatefulWidget {
  const JobFilterOptionScreen({super.key});

  @override
  State<JobFilterOptionScreen> createState() => _JobFilterOptionScreenState();
}

class _JobFilterOptionScreenState extends State<JobFilterOptionScreen> {
  TextEditingController positionNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController minimumSalaryController = TextEditingController();
  TextEditingController maximunSalaryController = TextEditingController();
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

  final List<String> experienceOptions = ['0-1 years', '1-3 years', '3-5 years', '5+ years'];
  String? employmentType;

  final List<String> employmentTypeOption = [
    'Casual',
    'Temporary',
    'Contract',
    'Part time',
    'Full time',
    'Permanent',
    'Freelance',
    'Apprenticeship',
    'Internship'
  ];

  String? schedule;

  final List<String> scheduleOption = [
    '8 Hour shift',
    '10 Hour shift',
    '12 Hour shift',
    'Less than 8 hours',
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

  final List<String> salaryTypes = ['Daily', 'Hourly', 'Monthly', 'Weekly', 'Yearly'];


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
                child: Text('Position Name (Optional)'),
              ),
              CommonTextField(
                  hintText: 'Position Name (Optional)',
                  controller: positionNameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Position Name is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Company Name (Optional)'),
              ),
              CommonTextField(
                  hintText: 'Company Name (Optional)',
                  controller: companyNameController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Company Name is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Required Work Experience'),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: experience,
                  dropdownColor: Colors.white,
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
                  validator: RequiredValidator(errorText: 'Experience is required'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Schedule'),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: schedule,
                  dropdownColor: Colors.white,
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
                  validator: RequiredValidator(errorText: 'schedule is required'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Salary'),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: salaryType,
                      dropdownColor: Colors.white,
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
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonTextField(
                        hintText: 'AU\$0.00',
                        labelText: 'Min Salary',
                        controller: minimumSalaryController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'minimum Salary is required'),
                        ]).call),
                  ),
                  Expanded(
                    child: CommonTextField(
                        hintText: 'AU\$0.00',
                        labelText: 'Max Salary',
                        controller: maximunSalaryController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'maximun Salary is required'),
                        ]).call),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

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
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: industryType,
                  dropdownColor: Colors.white,
                  items: industryTypeOption.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 10),
                      ),
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
                  validator: RequiredValidator(errorText: 'Industry Type'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonFormField<String>(
                  value: employmentType,
                  dropdownColor: Colors.white,
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
                  validator: RequiredValidator(errorText: 'Job Type'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
              const SizedBox(
                height: 15,
              ),

              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('How many positions are open ? (Optional)'),
              ),
              CommonTextField(
                  hintText: '10',
                  controller: openingsController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'How many positions are open is required'),
                  ]).call),
              // const Padding(
              //   padding: EdgeInsets.only(left: 25),
              //   child: Text('How long should this job posting be active?'),
              // ),
              // const SizedBox(
              //   height: 15,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 25, right: 25),
              //   child: Column(
              //     children: [
              //       DropdownButtonFormField<String>(
              //         value: timeOfAdd,
              //         dropdownColor: Colors.white,
              //         items: timeOfAddOption.map((String value) {
              //           return DropdownMenuItem<String>(
              //             value: value,
              //             child: Text(value),
              //           );
              //         }).toList(),
              //         onChanged: (newValue) {
              //           setState(() {
              //             timeOfAdd = newValue!;
              //           });
              //         },
              //         decoration: const InputDecoration(
              //           labelText: 'How long this add will show',
              //           border: OutlineInputBorder(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  log('Position Name: ${positionNameController.text}');
                  log('Company Name: ${companyNameController.text}');
                  log('Employment Type: $employmentType');
                  log('Experience: $experience');
                  Get.to(
                      ShowJobsFilterDataScreen(
                        companyName: companyNameController.text,
                        employmentTypeOption: employmentType,
                        experienceOptions: experience,
                        positionName: positionNameController.text,
                      )
                  );
                  },
                child: Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF730A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Filter Job",
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
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
