import 'dart:convert';
import 'dart:developer';
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
      List<dynamic> restaurants = data['results'];

      // Fetch additional details for each restaurant
      for (var restaurant in restaurants) {
        String placeId = restaurant['place_id'];
        try {
          final openingHours = await _fetchRestaurantDetails(placeId);
          restaurant['opening_hours'] = openingHours; // Add opening hours to restaurant data
        } catch (e) {
          print("Failed to fetch details for $placeId: $e");
        }
      }

      setState(() {
        _restaurants = restaurants;
        _filteredRestaurants = _restaurants;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  String _formatTime(dynamic time) {
    // Check if time is a string or an integer and ensure it's treated as an integer
    int formattedTime = int.parse(time.toString());

    final hours = formattedTime ~/ 100;
    final minutes = formattedTime % 100;
    final period = hours >= 12 ? 'PM' : 'AM';
    final formattedHours = hours > 12 ? hours - 12 : hours == 0 ? 12 : hours;
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    return '$formattedHours:$formattedMinutes $period';
  }


  Future<Map<String, String>> _fetchRestaurantDetails(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&fields=opening_hours&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Log raw opening_hours data to debug
      final openingHours = data['result']['opening_hours'];
      log("API Response: $openingHours"); // Log the raw opening_hours data

      if (openingHours != null) {
        Map<String, String> times = {};

        // Handling weekday_text (e.g., "Monday: 9:00 AM – 10:00 PM")
        if (openingHours['weekday_text'] != null) {
          for (var day in openingHours['weekday_text']) {
            final parts = day.split(':'); // Split "Monday: 9:00 AM – 10:00 PM"
            if (parts.length > 1) {
              final timeRange = parts[1].trim().replaceAll('–', '-'); // Replace the special dash
              final timeParts = timeRange.split(' - '); // Split "9:00 AM - 10:00 PM"
              if (timeParts.length == 2) {
                times['opening'] = timeParts[0].trim(); // Extract opening time
                times['closing'] = timeParts[1].trim(); // Extract closing time
              }
            }
          }
        }

        // Handling periods (time in 24-hour format, like {open: {time: 0900}})
        if (openingHours['periods'] != null) {
          for (var period in openingHours['periods']) {
            final openTime = period['open'] != null ? _formatTime(period['open']['time']) : '';
            final closeTime = period['close'] != null ? _formatTime(period['close']['time']) : '';

            if (openTime.isNotEmpty && closeTime.isNotEmpty) {
              times['opening'] = openTime;
              times['closing'] = closeTime;
            }
          }
        }

        // Log the formatted opening hours
        log("Formatted opening hours: $times");
        return times; // Return formatted opening hours
      }
      return {}; // Return empty if no opening hours available
    } else {
      throw Exception('Failed to fetch details');
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

                // Extract opening and closing times from restaurant data
                final openingHours = restaurant['opening_hours'];
                String openingTime = 'Not Available';
                String closingTime = 'Not Available';

                if (openingHours != null && openingHours.isNotEmpty) {
                  openingTime = openingHours['opening'] ?? 'Not Available';
                  closingTime = openingHours['closing'] ?? 'Not Available';
                }

                log('openingTime: $openingTime, closingTime: $closingTime'); // Log the times for debugging

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ResturentDetailsScreen(
                        name: name.toString(),
                        rating: rating,
                        desc: 'No Description Available',
                        openingTime: openingTime,
                        closingTime: closingTime,
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
