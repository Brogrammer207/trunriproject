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
import 'package:trunriproject/widgets/appTheme.dart';
import 'package:trunriproject/widgets/helper.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../model/bannerModel.dart';
import '../model/categoryModel.dart';
import 'Controller.dart';
import 'bottom_bar.dart';
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
  final apiKey = 'AIzaSyAP9njE_z7lH2tii68WLoQGju0DF8KryXA'; // Replace with your API key
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
    });
  }

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
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=restaurant&keyword=indian&key=$apiKey';

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
  //
  // Future<void> _launchMap(double lat, double lng) async {
  //   final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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
                    const SizedBox(width: 16),
                    IconBtnWithCounter(
                      svgSrc: "assets/images/navigation.png",
                      press: () => {},
                    ),
                    const SizedBox(width: 8),
                    IconBtnWithCounter(
                      svgSrc: "assets/images/notification.png",
                      numOfitem: 3,
                      press: () {},
                    ),
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
              SizedBox(
                height: 100,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // padEnds: false,
                        // controller: PageController(viewportFraction: .2),
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                // Get.to(() => CategoryScreen(
                                //       keyId: category[index].name,
                                //     ));
                              },
                              child: CategoryCard(
                                  icon: category[index].imageUrl, text: category[index].name, press: () {}));
                        });
                  },
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionTitle(
                      title: "Upcoming Events",
                      press: () {},
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
              const SizedBox(height: 20),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SectionTitle(
                      title: "Near By Accommodation",
                      press: () {},
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          demoProducts.length,
                          (index) {
                            if (demoProducts[index].isPopular) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ProductCard(product: demoProducts[index], onPress: () => {}),
                              );
                            }

                            return const SizedBox.shrink(); // here by default width and height is 0
                          },
                        ),
                        const SizedBox(width: 20),
                      ],
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
                      title: "Near By Restaurant",
                      press: () {},
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
                          resturentlong =lng.toString();





                        return GestureDetector(
                          onTap: () {
                            log('message');
                            Get.to(ResturentDetailsScreen(
                                name: name.toString(),
                                rating: rating,
                                desc: description.toString(),
                                openingTime: openingHours.toString(),
                                closingTime: closingTime.toString(),
                                address: address.toString(),
                                image: photoUrl.toString()),arguments: [lat,lng]);
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFECDF),
                              borderRadius: BorderRadius.circular(11)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFECDF),
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
