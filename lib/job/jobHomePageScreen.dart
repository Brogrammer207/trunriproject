import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trunriproject/job/addJobScreen.dart';

import '../home/search_field.dart';
import 'jobDetailsScreen.dart';

class JobHomePageScreen extends StatefulWidget {
  const JobHomePageScreen({super.key});

  @override
  State<JobHomePageScreen> createState() => _JobHomePageScreenState();
}

class _JobHomePageScreenState extends State<JobHomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Job'),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
              onTap: () {
                Get.to(const AddJobScreen());
              },
              child: const Icon(Icons.add_circle_outline_outlined)),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SearchField(),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  var Documents = snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: Documents.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data = Documents[index].data() as Map<String, dynamic>;

                        final DateTime postDate = data['postDate'].toDate();
                        final DateTime now = DateTime.now();
                        final Duration difference = now.difference(postDate);
                        String timeAgo;

                        if (difference.inDays == 0) {
                          timeAgo = 'Today';
                        } else if (difference.inDays == 1) {
                          timeAgo = '1 day ago';
                        } else {
                          timeAgo = '${difference.inDays} days ago';
                        }

                        return GestureDetector(
                          onTap: (){
                            Get.to(JobDetailsScreen(data: data,));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10, right: 10,bottom: 10),
                                padding: const EdgeInsets.all(15),
                                height: 160,
                                decoration:
                                BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [ BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(
                                        0.2,
                                        0.2,
                                      ),
                                      blurRadius: 1,
                                    ),],
                                    borderRadius: BorderRadius.circular(11)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['positionName'],
                                      style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.shopping_bag_outlined,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          data['experience'],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const VerticalDivider(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        const Icon(
                                          Icons.monetization_on_rounded,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.red.shade200,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child:    Text(
                                            data['salary'],
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const VerticalDivider(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        const Icon(
                                          Icons.navigation_rounded,
                                          size: 15,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          data['address'] ?? "",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.description_outlined, size: 15),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            data['jobDescription'],
                                            style: const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Text(
                                            data['industryType'],
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          '-',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child:   Text(
                                            data['employmentType'],
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),

                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          '-',
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.green.shade200,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child:   Text(
                                            data['department'] ?? "",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),

                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      timeAgo,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 10,
                                  right: 20,
                                  child: Image.asset('assets/icons/save.png',height: 25,))
                            ],
                          ),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}
