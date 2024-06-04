import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/resturentItemListScreen.dart';

import '../accommodation/accommodationHomeScreen.dart';
import '../accommodation/accommodationOptionScreen.dart';
import 'groceryStoreListScreen.dart';

class ExplorScreen extends StatefulWidget {
  const ExplorScreen({super.key});

  @override
  State<ExplorScreen> createState() => _ExplorScreenState();
}

class _ExplorScreenState extends State<ExplorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Discover Items'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Get.to(const ResturentItemListScreen());
              },
              leading: Image.asset('assets/images/restaurent.png'),
              title: const Text('Restaurant'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              onTap: (){
                Get.to(GroceryStoreListScreen());
              },
              leading: Image.asset('assets/images/store.png'),
              title: const Text('Grocery Stores'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              leading: Image.asset('assets/images/accommodation.png'),
              title: const Text('Accommodation'),
              onTap: (){
                Get.to(const Accommodationoptionscreen());
              },
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              leading: Image.asset('assets/images/events.png'),
              title: const Text('Events'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            const Divider(
              height: 10,
            ),
            ListTile(
              leading: Image.asset('assets/images/job.png'),
              title: const Text('Jobs'),
              trailing: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
