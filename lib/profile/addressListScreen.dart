import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  List<DocumentSnapshot> restaurants = [];

  Future<void> _fetchUserRestaurants() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not logged in
      return;
    }

    final userId = user.uid;
    final querySnapshot =
        await FirebaseFirestore.instance.collection('nativeAddress').where('userId', isEqualTo: userId).get();

    setState(() {
      restaurants = querySnapshot.docs;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Address List'),
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                'Native Address',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('nativeAddress')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('User not found'));
                }
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return Center(
                  child: Stack(
                    children: [
                      Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          padding: const EdgeInsets.all(15),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Street: ${userData['Street']}'),
                              Text('city: ${userData['city']}'),
                              Text('town: ${userData['town']}'),
                              Text('state: ${userData['state']}'),
                              Text('zipcode: ${userData['zipcode']}'),
                              Text('country: ${userData['country']}'),
                            ],
                          )),
                      const Positioned(
                          right: 30,
                          top: 10,
                          child: Text(
                            'Edit',
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                          )),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30,),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                'Current Address',
                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('currentLocation')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('User not found'));
                }
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return Center(
                  child: Stack(
                    children: [
                      Container(
                          width: Get.width,
                          margin: const EdgeInsets.only(left: 15, right: 15),
                          padding: const EdgeInsets.all(15),
                          decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Street: ${userData['Street']}'),
                              Text('city: ${userData['city']}'),
                              Text('town: ${userData['town']}'),
                              Text('state: ${userData['state']}'),
                              Text('zipcode: ${userData['zipcode']}'),
                              Text('country: ${userData['country']}'),
                            ],
                          )),
                      const Positioned(
                          right: 30,
                          top: 10,
                          child: Text(
                            'Edit',
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                          )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
