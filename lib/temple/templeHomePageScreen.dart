import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/resturentDetailsScreen.dart';
import 'package:http/http.dart' as http;
import 'package:trunriproject/home/search_field.dart';
import '../home/Controller.dart';

class TempleHomePageScreen extends StatefulWidget {
  const TempleHomePageScreen({super.key});

  @override
  State<TempleHomePageScreen> createState() => _TempleHomePageScreenState();
}

class _TempleHomePageScreenState extends State<TempleHomePageScreen> {
  Position? _currentPosition;
  String templeLat = '';
  String templeLong = '';
  List<dynamic> _temples = [];
  List<dynamic> _filterTemples = [];
  final apiKey = 'AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU';
  final serviceController = Get.put(ServiceController());
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    searchController.addListener(_filterRestaurants);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTemples(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=35000&type=hindu_temple&keyword=temple&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (mounted) {
        setState(() {
          _temples = data['results'];
          _filterTemples = _temples;
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

      _fetchTemples(position.latitude, position.longitude);
    });
  }

  void _filterRestaurants() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filterTemples = _temples;
      });
    } else {
      setState(() {
        _filterTemples =
            _temples.where((restaurant) => restaurant['name'].toString().toLowerCase().contains(query)).toList();
      });
    }
  }

  String defaultImageUrl = 'https://via.placeholder.com/400';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF979797).withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Search Restaurant",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading // Show progress indicator when loading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.orange,
            ))
          : _temples.isEmpty // Check if the list is empty
              ? Center(child: Text("No temples found"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _filterTemples.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          final temple = _filterTemples[index];
                          final name = temple['name'];
                          final address = temple['vicinity'];
                          final rating = (temple['rating'] as num?)?.toDouble() ?? 0.0;
                          final description = temple['description'] ?? 'No Description Available';
                          final openingHours = temple['opening_hours'] != null
                              ? temple['opening_hours']['weekday_text']
                              : 'Not Available';
                          final closingTime = temple['closing_time'] ?? 'Not Available';
                          final photoReference =
                              temple['photos'] != null ? temple['photos'][0]['photo_reference'] : null;
                          final photoUrl = photoReference != null
                              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
                              : defaultImageUrl;
                          final lat = temple['geometry']['location']['lat'];
                          final lng = temple['geometry']['location']['lng'];

                          templeLat = lat.toString();
                          templeLong = lng.toString();

                          return GestureDetector(
                            onTap: () {
                              Get.to(
                                ResturentDetailsScreen(
                                  name: name.toString(),
                                  rating: rating,
                                  desc: description.toString(),
                                  openingTime: openingHours.toString(),
                                  closingTime: closingTime.toString(),
                                  address: address.toString(),
                                  image: photoUrl.toString(),
                                ),
                                arguments: [lat, lng],
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (photoUrl != null)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height: 130,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        imageUrl: photoUrl,
                                        errorWidget: (_, __, ___) => const Icon(Icons.person),
                                        placeholder: (_, __) => const SizedBox(),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
