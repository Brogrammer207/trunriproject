import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/resturentDetailsScreen.dart';
import 'package:http/http.dart' as http;
import 'Controller.dart';

class ResturentItemListScreen extends StatefulWidget {
  const ResturentItemListScreen({super.key});

  @override
  State<ResturentItemListScreen> createState() => _ResturentItemListScreenState();
}

class _ResturentItemListScreenState extends State<ResturentItemListScreen> {
  Position? _currentPosition;
  String resturentLat = '';
  String resturentlong = '';
  List<dynamic> _restaurants = [];
  List<dynamic> _filteredRestaurants = [];
  final apiKey = 'AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU';
  final serviceController = Get.put(ServiceController());
  bool _isLoading = true;
  final TextEditingController searchController = TextEditingController();
  String defaultImageUrl = 'https://via.placeholder.com/400';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Listen to searchController to filter restaurants
    searchController.addListener(_filterRestaurants);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchIndianRestaurants(double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=5000&type=restaurant&keyword=indian&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _restaurants = data['results'];
        _filteredRestaurants = _restaurants; // Initialize filtered list
        _isLoading = false;
      });
    } else {
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

      _fetchIndianRestaurants(position.latitude, position.longitude);
    });
  }

  void _filterRestaurants() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredRestaurants = _restaurants;
      });
    } else {
      setState(() {
        _filteredRestaurants = _restaurants
            .where((restaurant) => restaurant['name'].toString().toLowerCase().contains(query))
            .toList();
      });
    }
  }

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
              child: const Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange,))
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Restaurant List',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _filteredRestaurants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                final restaurant = _filteredRestaurants[index];
                final name = restaurant['name'];
                final address = restaurant['vicinity'];
                final rating = (restaurant['rating'] as num?)?.toDouble() ?? 0.0;
                final photoReference = restaurant['photos'] != null
                    ? restaurant['photos'][0]['photo_reference']
                    : null;
                final photoUrl = photoReference != null
                    ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
                    : defaultImageUrl;

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ResturentDetailsScreen(
                        name: name.toString(),
                        rating: rating,
                        desc: 'No Description Available',
                        openingTime: 'Not Available',
                        closingTime: 'Not Available',
                        address: address.toString(),
                        image: photoUrl.toString(),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            photoUrl,
                            height: 115,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
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

