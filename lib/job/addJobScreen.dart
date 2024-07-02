import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  TextEditingController experienceController = TextEditingController();
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


  void addJobs(){
    FirebaseFirestore.instance.collection('jobs').doc().set({
      'uid' : FirebaseAuth.instance.currentUser!.uid,
      'postDate' : DateTime.now(),
      'positionName' : positionNameController.text,
      'companyName' : companyNameController.text,
      'experience' : experienceController.text,
      'salary' : salaryController.text,
      'openings' : openingsController.text,
      'role' : roleController.text,
      'industryType' : industryTypeController.text,
      'department' : departmentController.text,
      'employmentType' : employmentTypeController.text,
      'roleCategory' : roleCategoryController.text,
      'eduction' : eductionController.text,
      'keySkills' : keySkillsController.text,
      'jobDescription' : jobDescriptionController.text,
      'aboutCompany' : aboutCompanyController.text,
    }).then((value){
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
                child: Text('Experience'),
              ),
              CommonTextField(
                  hintText: 'Experience',
                  controller: experienceController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Experience is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('Salary'),
              ),
              CommonTextField(
                  hintText: 'Salary',
                  controller: salaryController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Salary is required'),
                  ]).call),
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Text('How much Openings'),
              ),
              CommonTextField(
                  hintText: 'How much Openings',
                  controller: openingsController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'How much Openings is required'),
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
              CommonTextField(
                  hintText: 'Industry Type',
                  controller: industryTypeController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Industry Type is required'),
                  ]).call),
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
                child: Text('Employment Type'),
              ),
              CommonTextField(
                  hintText: 'Employment Type',
                  controller: employmentTypeController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Employment Type is required'),
                  ]).call),
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
                  margin: EdgeInsets.only(left: 25,right: 25),
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
