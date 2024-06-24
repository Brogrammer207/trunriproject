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
    'Queensland',
    'Victoria',
    'NSW',
    'South Australia',
    'Western Australia',
    'Northern Territory',
    'Tasmania'
  ];

  final List<String> cityImage = [
    'https://www.shutterstock.com/image-photo/port-douglas-beach-ocean-on-260nw-293091518.jpg',
    'https://cdn.britannica.com/50/96050-050-8BCE4FFD/Twelve-Apostles-sea-stacks-Port-Campbell-National.jpg',
    'https://storage.googleapis.com/stateless-www-wotif-com/2019/06/5d275d3c-hero.jpg',
    'https://cdn.britannica.com/82/94782-050-EB2E817A/Torrens-River-Adelaide-South-Australia.jpg',
    'https://www.planetware.com/wpimages/2022/02/western-australia-top-attractions-intro-paragraph-ningaloo.jpg',
    'https://www.aptouring.com/-/media/apt-responsive-website/australia/northern-territory/general-image-16-9/gi-a-au-nt-simpsons-gap-with-water-635020619-s-web-16-9.jpg',
    'https://a.travel-assets.com/findyours-php/viewfinder/images/res40/46000/46029-Salamanca-Place.jpg'
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
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('accommodation').where('city', isEqualTo: selectedCity).get();

      setState(() {
        accommodationList = querySnapshot.docs;
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FilterOptionScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const SearchField(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _showFilterBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.grey.shade200),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text('Filter')),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.filter_list)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.grey.shade200),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text('Saved')),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.save)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 80,
                child: ListView.builder(
                    itemCount: cityList.length,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final imageUrl =
                      (index < cityImage.length) ? cityImage[index] : 'https://via.placeholder.com/150';
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCity = cityList[index];
                            fetchAccommodationData();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5, left: 5),
                          height: 80,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: selectedCity == cityList[index] ? Colors.orange : Colors.black,
                              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.fill)),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              cityList[index],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              if (selectedCity != null) ...[
                GridView.builder(
                  itemCount: accommodationList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 10, // Spacing between columns
                    mainAxisSpacing: 10, // Spacing between rows
                    childAspectRatio: 0.72, // Aspect ratio of each grid item
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
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Address: ',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: data['address'] ?? '',
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )
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
