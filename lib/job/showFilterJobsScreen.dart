import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowJobsFilterDataScreen extends StatefulWidget {
  final String? experienceOptions;
  final String? employmentTypeOption;
  final String? positionName;
  final String? companyName;



  ShowJobsFilterDataScreen({Key? key,  this.experienceOptions,  this.employmentTypeOption,this.positionName,this.companyName,}) : super(key: key);

  @override
  State<ShowJobsFilterDataScreen> createState() => _ShowJobsFilterDataScreenState();
}

class _ShowJobsFilterDataScreenState extends State<ShowJobsFilterDataScreen> {
  late Future<List<Map<String, dynamic>>> _filteredData;

  @override
  void initState() {
    super.initState();
    _filteredData = _fetchFilteredData();
    log("fffffff${widget.companyName}");

  }

  Future<List<Map<String, dynamic>>> _fetchFilteredData() async {
    List<Map<String, dynamic>> filteredList = [];
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('jobs').get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // String positionName = data['positionName'] ?? '';
        String companyName = data['companyName'] ?? '';
        // String experience = data['experience'] ?? '';
        // String employmentType = data['employmentType'] ?? '';


        // bool positionNameFilter = widget.positionName == null || widget.positionName == positionName;
        bool companyNameFilter = widget.companyName == null || widget.companyName == companyName;
        // bool experienceOptions = widget.experienceOptions == null || widget.experienceOptions == experience;
        // bool employmentTypeOption = widget.employmentTypeOption == null || widget.employmentTypeOption == employmentType;

        if ( companyNameFilter) {
          filteredList.add(data);
        }
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Data'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _filteredData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10, // Spacing between columns
                mainAxisSpacing: 10, // Spacing between rows
                childAspectRatio: 0.8, // Aspect ratio of each grid item
              ),
              itemBuilder: (context, index) {
                Map<String, dynamic> item = snapshot.data![index];
                String name = item['companyName'];
                String positionname = item['positionName'];
                // String imageUrl = item['images'].toString();
                // imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '');

                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image.network(
                      //   imageUrl,
                      //   height: 130,
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      //   errorBuilder: (context, error, stackTrace) {
                      //     return const Text('Image failed to load');
                      //   },
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address: ${item['address'] ?? ''}',
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
