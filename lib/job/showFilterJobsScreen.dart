import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowJobsFilterDataScreen extends StatefulWidget {
  final String companyName;
  final String positionName;
  final String? employmentTypeOption;
  final String? experienceOptions;

  const ShowJobsFilterDataScreen({
    Key? key,
    required this.companyName,
    required this.positionName,
    this.employmentTypeOption,
    this.experienceOptions,
  }) : super(key: key);

  @override
  _ShowJobsFilterDataScreenState createState() => _ShowJobsFilterDataScreenState();
}

class _ShowJobsFilterDataScreenState extends State<ShowJobsFilterDataScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchFilteredJobs() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('jobs')
        .where('companyName', isEqualTo: widget.companyName)
        .where('positionName', isEqualTo: widget.positionName)
        .get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Jobs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFilteredJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching jobs data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No jobs found'));
          } else {
            List<Map<String, dynamic>> jobs = snapshot.data!;
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index];
                return ListTile(
                  title: Text(job['positionName']),
                  subtitle: Text(job['companyName']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
