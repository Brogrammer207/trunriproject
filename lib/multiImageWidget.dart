import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageWidget extends StatefulWidget {
  const MultiImageWidget({
    super.key,
    required this.files,
    required this.title,
    required this.validation,
    required this.filesPicked,
    this.imageOnly,
  });

  final List<File> files;
  final String title;
  final bool validation;
  final bool? imageOnly;
  final Function(List<File> files) filesPicked;

  @override
  State<MultiImageWidget> createState() => _MultiImageWidgetState();
}

class _MultiImageWidgetState extends State<MultiImageWidget> {
  List<File> files = [];

  bool get validation => widget.validation ? files.isEmpty : false;

  Future<void> pickImages() async {
    if (widget.imageOnly == true) {
      final pickedFiles = await ImagePicker().pickMultiImage(imageQuality: 80);
      if (pickedFiles != null) {
        files = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        widget.filesPicked(files);
        setState(() {});
      }
    } else {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        files = result.paths.map((path) => File(path!)).toList();
        widget.filesPicked(files);
        setState(() {});
      }
    }
  }

  Future<void> pickImagesNew() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Files'.tr),
                onTap: () async {
                  Get.back();
                  if (widget.imageOnly == true) {
                    final pickedFiles = await ImagePicker().pickMultiImage(imageQuality: 80);
                    if (pickedFiles != null) {
                      files = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
                      widget.filesPicked(files);
                      setState(() {});
                    }
                  } else {
                    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
                    if (result != null) {
                      files = result.paths.map((path) => File(path!)).toList();
                      widget.filesPicked(files);
                      setState(() {});
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Camera'.tr),
                onTap: () async {
                  Get.back();
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      files.add(File(pickedFile.path));
                    });
                    widget.filesPicked(files);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: Text('Cancel'.tr),
                onTap: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    files = widget.files;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          widget.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xff2F2F2F), fontSize: 16),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: pickImagesNew,
          child: files.isEmpty
              ? Container(
            width: size.width,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                const SizedBox(height: 5),
                Text("Upload Photo", style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: files.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    files[index],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.network(
                      files[index].path,
                      errorBuilder: (_, __, ___) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload),
                          Text(
                            files[index].path.toString().split("/").last,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

