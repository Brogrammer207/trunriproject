import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/product.dart';
import 'package:trunriproject/home/product_cart.dart';
import 'package:trunriproject/home/resturentDetailsScreen.dart';
import 'package:trunriproject/home/resturentItemListScreen.dart';
import 'package:trunriproject/widgets/appTheme.dart';
import 'package:trunriproject/widgets/helper.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../accommodation/accommodationHomeScreen.dart';
import '../accommodation/lookingForAPlaceScreen.dart';
import '../job/jobHomePageScreen.dart';
import '../model/bannerModel.dart';
import '../model/categoryModel.dart';
import '../temple/templeHomePageScreen.dart';
import 'Controller.dart';
import 'bottom_bar.dart';
import 'groceryStoreListScreen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'section_title.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  String resturentLat = '';
  String resturentlong = '';
  List<dynamic> _restaurants = [];
  String groceryStoreLat = '';
  String groceryStoreLong = '';
  List<dynamic> _groceryStores = [];
  final apiKey = 'AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU';
  final serviceController = Get.put(ServiceController());
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchImageData();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      double currentLatitude = position.latitude;
      double currentLongitude = position.longitude;
      serviceController.currentlat = currentLatitude;
      serviceController.currentlong = currentLongitude;

      _fetchIndianRestaurants(position.latitude, position.longitude);
      _fetchGroceryStores(position.latitude, position.longitude);
      _fetchTemples(position.latitude,position.longitude);
    });
  }

  String defaultImageUrl = 'https://via.placeholder.com/400';
  Future<void> _launchMap(double lat, double lng) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _fetchIndianRestaurants(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=4000&type=restaurant&keyword=indian&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _restaurants = data['results'];
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> _fetchGroceryStores(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=4000&type=grocery_or_supermarket&keyword=grocery&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          _groceryStores = data['results'];
        });
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  String templeLat = '';
  String templeLong = '';
  List<dynamic> _temples = [];
  bool _isLoading = true;

  Future<void> _fetchTemples(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=35000&type=hindu_temple&keyword=temple&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          _temples = data['results'];
          _isLoading = false; // Set _isLoading to false after data is fetched
        });
      }
    } else {
      setState(() {
        _isLoading = false; // Set _isLoading to false even if the fetch fails
      });
      throw Exception('Failed to fetch data');
    }
  }

  List<String> imageUrls = [];
  Future<List<String>> fetchImageData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('banners').get();

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String imageUrl = data['imageUrl'];
        imageUrls.add(imageUrl);
      });
    } catch (e) {
      print("Error fetching image data: $e");
    }

    return imageUrls;
  }

  RxDouble sliderIndex = (0.0).obs;

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: SearchField()),


                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('banners').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching products'),
                    );
                  }

                  List<BannerModel> banner = snapshot.data!.docs.map((doc) {
                    return BannerModel.fromMap(doc.id, doc.data());
                  }).toList();

                  return Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: (value, _) {
                              sliderIndex.value = value.toDouble();
                            },
                            autoPlayCurve: Curves.ease,
                            height: height * .20),
                        items: List.generate(
                            banner.length,
                            (index) => Container(
                                width: width,
                                margin: EdgeInsets.symmetric(horizontal: width * .01),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: banner[index].imageUrl,
                                    errorWidget: (_, __, ___) => const SizedBox(),
                                    placeholder: (_, __) => const SizedBox(),
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                      ),
                    ],
                  );
                },
              ),
              DotsIndicator(
                dotsCount: 3,
                position: currentIndex.round(),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching products'),
                    );
                  }

                  List<Category> category = snapshot.data!.docs.map((doc) {
                    return Category.fromMap(doc.id, doc.data());
                  }).toList();
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          // padEnds: false,
                          // controller: PageController(viewportFraction: .2),
                          itemCount: category.length,
                          itemBuilder: (context, index) {
                           return CategoryCard(
                               icon: category[index].imageUrl,
                               text: category[index].name,
                               press: () {
                                 if (category[index].name == 'Temples') {
                                   Get.to(const TempleHomePageScreen());
                                 } else if(category[index].name == 'Grocery stores') {
                                   Get.to(const GroceryStoreListScreen());
                                 }
                                 else if(category[index].name == 'Accommodation') {
                                   Get.to(const LookingForAPlaceScreen());
                                 }
                                 else if(category[index].name == 'Restaurants') {
                                   Get.to(const ResturentItemListScreen());
                                 }
                                 else if(category[index].name == 'Jobs') {
                                   Get.to(const JobHomePageScreen());
                                 }
                                 else if(category[index].name == 'Events') {
                                   Get.to(const JobHomePageScreen());
                                 }
                               }
                           );

                          }),
                    ),
                  );
                },
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionTitle(
                      title: "Upcoming Events",
                      press: () {

                      },
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SpecialOfferCard(
                          image: "assets/images/singing.jpeg",
                          category: "Singing Show",
                          numOfBrands: 18,
                          press: () {},
                        ),
                        SpecialOfferCard(
                          image: "assets/images/fashion.jpeg",
                          category: "Fashion Show",
                          numOfBrands: 24,
                          press: () {},
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 20),
              //       child: SectionTitle(
              //         title: "Near By Accommodation",
              //         press: () {
              //           Get.to(const LookingForAPlaceScreen());
              //         },
              //       ),
              //     ),
              //     SingleChildScrollView(
              //       scrollDirection: Axis.horizontal,
              //       child: Row(
              //         children: [
              //           ...List.generate(
              //             demoProducts.length,
              //             (index) {
              //               if (demoProducts[index].isPopular) {
              //                 return Padding(
              //                   padding: const EdgeInsets.only(left: 20),
              //                   child: ProductCard(product: demoProducts[index], onPress: () => {}),
              //                 );
              //               }
              //
              //               return const SizedBox.shrink(); // here by default width and height is 0
              //             },
              //           ),
              //           const SizedBox(width: 20),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionTitle(
                      title: "Near By Restaurants",
                      press: () {
                        Get.to(const ResturentItemListScreen());
                      },
                    ),
                  ),
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = _restaurants[index];
                        final name = restaurant['name'];
                        final address = restaurant['vicinity'];
                        final rating = (restaurant['rating'] as num?)?.toDouble() ?? 0.0;
                        final reviews = restaurant['reviews'];
                        final description = restaurant['description'] ?? 'No Description Available';
                        final openingHours = restaurant['opening_hours'] != null
                            ? restaurant['opening_hours']['weekday_text']
                            : 'Not Available';
                        final closingTime = restaurant['closing_time'] ?? 'Not Available';
                        final photoReference =
                            restaurant['photos'] != null ? restaurant['photos'][0]['photo_reference'] : null;
                        final photoUrl = photoReference != null
                            ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
                            : null;
                        final lat = restaurant['geometry']['location']['lat'];
                        final lng = restaurant['geometry']['location']['lng'];

                        resturentLat = lat.toString();
                        resturentlong = lng.toString();

                        return GestureDetector(
                          onTap: () {
                            log('message');
                            Get.to(
                                ResturentDetailsScreen(
                                    name: name.toString(),
                                    rating: rating,
                                    desc: description.toString(),
                                    openingTime: openingHours.toString(),
                                    closingTime: closingTime.toString(),
                                    address: address.toString(),
                                    image: photoUrl.toString()),
                                arguments: [lat, lng]);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 118,
                                    width: 118,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: photoUrl != null
                                        ? Image.network(
                                            photoUrl,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.fill,
                                          )
                                        : SizedBox(),
                                  ),
                                  const SizedBox(height: 4), // Add space between the image and the text
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 56, // Adjust width if needed
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12, // Adjust the font size as needed
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2, // Allow text to wrap to 2 lines if needed
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionTitle(
                      title: "Near By Grocery Stores",
                      press: () {
                        Get.to(const GroceryStoreListScreen());
                      },
                    ),
                  ),
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _groceryStores.length,
                      itemBuilder: (context, index) {
                        final groceryStore = _groceryStores[index];
                        final name = groceryStore['name'];
                        final address = groceryStore['vicinity'];
                        final rating = (groceryStore['rating'] as num?)?.toDouble() ?? 0.0;
                        final description = groceryStore['description'] ?? 'No Description Available';
                        final openingHours = groceryStore['opening_hours'] != null
                            ? groceryStore['opening_hours']['weekday_text']
                            : 'Not Available';
                        final closingTime = groceryStore['closing_time'] ?? 'Not Available';
                        final photoReference =
                            groceryStore['photos'] != null ? groceryStore['photos'][0]['photo_reference'] : null;
                        final photoUrl = photoReference != null
                            ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
                            : defaultImageUrl;
                        final lat = groceryStore['geometry']['location']['lat'];
                        final lng = groceryStore['geometry']['location']['lng'];

                        groceryStoreLat = lat.toString();
                        groceryStoreLong = lng.toString();

                        return GestureDetector(
                          onTap: () {
                            log('message');
                            Get.to(
                                ResturentDetailsScreen(
                                    name: name.toString(),
                                    rating: rating,
                                    desc: description.toString(),
                                    openingTime: openingHours.toString(),
                                    closingTime: closingTime.toString(),
                                    address: address.toString(),
                                    image: photoUrl.toString()),
                                arguments: [lat, lng]);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 118,
                                    width: 118,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      // image: DecorationImage(
                                      //   image: NetworkImage(icon),
                                      //   fit: BoxFit.fill,
                                      // ),
                                    ),
                                    child: photoUrl != null
                                        ? Image.network(
                                            photoUrl,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.fill,
                                          )
                                        : SizedBox(),
                                  ),
                                  const SizedBox(height: 4), // Add space between the image and the text
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 56, // Adjust width if needed
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12, // Adjust the font size as needed
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2, // Allow text to wrap to 2 lines if needed
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  //
                                  // InkWell(
                                  //     onTap: () {
                                  //       _launchMap(lat, lng);
                                  //     },
                                  //     child: Container(
                                  //         padding: EdgeInsets.all(10),
                                  //         decoration: BoxDecoration(
                                  //           color: AppTheme.mainColor,
                                  //         ),
                                  //         child: Text(
                                  //           'Get Directions',
                                  //           style: TextStyle(color: Colors.white),
                                  //         )))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "Near By Accommodations",
                  press: () {
                    Get.to(const LookingForAPlaceScreen());
                  },
                ),
              ),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('accommodation').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No accommodations found'));
                    }
                    return ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        List<dynamic> images = data['images'] ?? [];

                        return Card(
                          color: Colors.white,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                                  height: 140,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: images.isNotEmpty
                                      ? Image.network(
                                          images[0],
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width,
                                        )
                                      : SizedBox(),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 56, // Adjust width if needed
                                  child: Text(
                                    data['fullAddress'] ?? 'No Address',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12, // Adjust the font size as needed
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2, // Allow text to wrap to 2 lines if needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "Find Your Job",
                  press: () {
                    Get.to(const JobHomePageScreen());
                  },
                ),
              ),
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No jobs found'));
                    }
                    return ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        List<dynamic> images = data['images'] ?? [];

                        return Card(
                          color: Colors.white,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 120, // Adjust width if needed
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10,),
                                      Text(
                                        "Name - ${data['companyName'] ?? 'No companyName'}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12, // Adjust the font size as needed
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, // Allow text to wrap to 2 lines if needed
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Department - ${data['department'] ?? 'No department'}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12, // Adjust the font size as needed
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, // Allow text to wrap to 2 lines if needed
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "Eduction - ${data['eduction'] ?? 'No eduction'}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12, // Adjust the font size as needed
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, // Allow text to wrap to 2 lines if needed
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "EmploymentType - ${data['employmentType'] ?? 'No employmentType'}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12, // Adjust the font size as needed
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2, // Allow text to wrap to 2 lines if needed
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionTitle(
                      title: "Near By Temples",
                      press: () {
                        Get.to(const TempleHomePageScreen());
                      },
                    ),
                  ),
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _temples.length,
                      itemBuilder: (context, index) {
                        final temples = _temples[index];
                        final name = temples['name'];
                        final address = temples['vicinity'];
                        final rating = (temples['rating'] as num?)?.toDouble() ?? 0.0;
                        final reviews = temples['reviews'];
                        final description = temples['description'] ?? 'No Description Available';
                        final openingHours = temples['opening_hours'] != null
                            ? temples['opening_hours']['weekday_text']
                            : 'Not Available';
                        final closingTime = temples['closing_time'] ?? 'Not Available';
                        final photoReference =
                        temples['photos'] != null ? temples['photos'][0]['photo_reference'] : null;
                        final photoUrl = photoReference != null
                            ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=35000&photoreference=$photoReference&key=$apiKey'
                            : null;
                        final lat = temples['geometry']['location']['lat'];
                        final lng = temples['geometry']['location']['lng'];

                        resturentLat = lat.toString();
                        resturentlong = lng.toString();

                        return GestureDetector(
                          onTap: () {
                            log('message');
                            Get.to(
                                ResturentDetailsScreen(
                                    name: name.toString(),
                                    rating: rating,
                                    desc: description.toString(),
                                    openingTime: openingHours.toString(),
                                    closingTime: closingTime.toString(),
                                    address: address.toString(),
                                    image: photoUrl.toString()),
                                arguments: [lat, lng]);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration:
                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    height: 118,
                                    width: 118,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      // image: DecorationImage(
                                      //   image: NetworkImage(icon),
                                      //   fit: BoxFit.fill,
                                      // ),
                                    ),
                                    child: photoUrl != null
                                        ? Image.network(
                                      photoUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fill,
                                    )
                                        : SizedBox(),
                                  ),
                                  const SizedBox(height: 4), // Add space between the image and the text
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 56, // Adjust width if needed
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12, // Adjust the font size as needed
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2, // Allow text to wrap to 2 lines if needed
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  //
                                  // InkWell(
                                  //     onTap: () {
                                  //       _launchMap(lat, lng);
                                  //     },
                                  //     child: Container(
                                  //         padding: EdgeInsets.all(10),
                                  //         decoration: BoxDecoration(
                                  //           color: AppTheme.mainColor,
                                  //         ),
                                  //         child: Text(
                                  //           'Get Directions',
                                  //           style: TextStyle(color: Colors.white),
                                  //         )))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFECDF),
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(icon),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 4), // Add space between the image and the text
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 56, // Adjust width if needed
            child: Text(
              text.capitalize!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10, // Adjust the font size as needed
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Allow text to wrap to 2 lines if needed
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 242,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black54,
                        Colors.black38,
                        Colors.black26,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Days")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
