import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import '../widgets/commomButton.dart';
import '../widgets/helper.dart';
import '../widgets/imageWidget.dart';
import 'flatmatesScreen.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({super.key});

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  List<File> selectedFiles = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<void> saveMediaData() async {
    OverlayEntry loader = NewHelper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    User? user = _auth.currentUser;
    if (user != null) {
      List<String> imageUrls = [];
      for (File file in selectedFiles) {
        String fileName = path.basename(file.path);
        Reference storageReference = _storage.ref().child('accommodations/${user.uid}/$fileName');
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      QuerySnapshot querySnapshot =
          await _firestore.collection('accommodation').where('uid', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await _firestore.collection('accommodation').doc(doc.id).update({
            'images': imageUrls,
            'Give your listing a title': titleController.text.trim(),
            'Add a description': descriptionController.text.trim(),
          });
        }
        Get.to(const FlatmateScreen());
        NewHelper.hideLoader(loader);
        showToast('Media saved');
      } else {
        NewHelper.hideLoader(loader);
        print('No matching document found');
      }
    } else {
      NewHelper.hideLoader(loader);
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Step 4: Media',
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
                'Add some photos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: ImageWidget(
                  files: selectedFiles,
                  validation: true,
                  imageOnly: true,
                  filesPicked: (List<File> pickedFiles) {
                    setState(() {
                      selectedFiles = pickedFiles;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Give your listing a title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: 'No deposit room in Tooley Street',
                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Add a description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: 'No deposit room in Tooley Street',
                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
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
                      saveMediaData();
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
