import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home/search_field.dart';
import 'filterOptionScreen.dart';

class LookingForAPlaceScreen extends StatefulWidget {
  const LookingForAPlaceScreen({super.key});

  @override
  State<LookingForAPlaceScreen> createState() => _LookingForAPlaceScreenState();
}

class _LookingForAPlaceScreenState extends State<LookingForAPlaceScreen> {
  final List<String> cityList = [
    'Sydney', 'Albury', 'Armidale', 'Bathurst', 'Blue Mountains', 'Broken Hill',
    'Melbourne', 'Canberra', 'Brisbane', 'Adelaide', 'Perth', 'Hobart', 'Darwin',
    'Gold Coast', 'Newcastle', 'Wollongong', 'Geelong', 'Cairns', 'Townsville',
    'Toowoomba', 'Ballarat', 'Bendigo', 'Launceston', 'Mackay', 'Rockhampton',
    'Bunbury', 'Bundaberg', 'Hervey Bay', 'Mildura', 'Wagga Wagga', 'Shepparton',
    'Gladstone', 'Port Macquarie', 'Tamworth', 'Orange', 'Dubbo', 'Geraldton',
    'Alice Springs', 'Kalgoorlie', 'Mount Gambier', 'Busselton', 'Bunbury',
    'Albany', 'Coffs Harbour', 'Lismore', 'Gympie', 'Burnie', 'Devonport',
    'Goulburn', 'Katherine', 'Broome'
  ];
  String? selectedCity;
  List<DocumentSnapshot> accommodationList = [];

  @override
  void initState() {
    super.initState();
    // Optionally set a default city
    selectedCity = cityList[0];
    fetchAccommodationData();
  }

  Future<void> fetchAccommodationData() async {
    if (selectedCity != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('accommodation')
          .where('city', isEqualTo: selectedCity)
          .get();

      setState(() {
        accommodationList = querySnapshot.docs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Book your room securely',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show the popup menu
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
                items: [
                  PopupMenuItem<String>(
                    value: 'filter',
                    child: Text('Filter'),
                  ),
                ],
              ).then((value) {
                // Handle the selection of the menu item
                if (value == 'filter') {
                  Get.to(FilterOptionScreen());
                  print('Filter action selected');
                }
              });
            },
          ),
          SizedBox(width: 15,)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15,right: 15),
          child: Column(
            children: [
              const SearchField(),
              const SizedBox(height: 10,),
              SizedBox(
                height: 35,
                child: ListView.builder(
                    itemCount: cityList.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCity = cityList[index];
                            fetchAccommodationData();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedCity == cityList[index] ? Colors.orange : Colors.black,
                          ),
                          child: Center(
                            child: Text(
                              cityList[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
              const SizedBox(height: 10,),
              if (selectedCity != null) ...[
                GridView.builder(
                  itemCount: accommodationList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10, // Spacing between columns
                    mainAxisSpacing: 10, // Spacing between rows
                    childAspectRatio: 0.8, // Aspect ratio of each grid item
                  ),
                  itemBuilder: (context, index) {
                    var data = accommodationList[index].data() as Map<String, dynamic>;
                    String imageUrl = data['images'].toString();
                    imageUrl = imageUrl.replaceAll('[', '').replaceAll(']', '');

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            imageUrl,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Image failed to load');
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Address: ${data['address'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),

                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
