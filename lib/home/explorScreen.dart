import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/resturentItemListScreen.dart';

class ExplorScreen extends StatefulWidget {
  const ExplorScreen({super.key});

  @override
  State<ExplorScreen> createState() => _ExplorScreenState();
}

class _ExplorScreenState extends State<ExplorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Items'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color(0xffF4EEF2),
                Color(0xffF4EEF2),
                Color(0xffE3EDF5),
              ],
            ),
          ),
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
            ],
          ),
        ),
      ),
    );
  }
}
