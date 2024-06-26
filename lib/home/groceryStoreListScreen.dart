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
import 'Controller.dart';

class GroceryStoreListScreen extends StatefulWidget {
  const GroceryStoreListScreen({super.key});

  @override
  State<GroceryStoreListScreen> createState() => _GroceryStoreListScreenState();
}

class _GroceryStoreListScreenState extends State<GroceryStoreListScreen> {
  Position? _currentPosition;
  String groceryStoreLat = '';
  String groceryStoreLong = '';
  List<dynamic> _groceryStores = [];
  final apiKey = 'AIzaSyDDl-_JOy_bj4MyQhYbKbGkZ0sfpbTZDNU';
  final serviceController = Get.put(ServiceController());
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

      _fetchGroceryStores(position.latitude, position.longitude);
    });
  }

  String defaultImageUrl = 'https://via.placeholder.com/400';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Expanded(child: SearchField()),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _isLoading // Show progress indicator when loading
          ? Center(child: CircularProgressIndicator())
          : _groceryStores.isEmpty // Check if the list is empty
              ? Center(child: Text("No grocery stores found"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Grocery Store List',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _groceryStores.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
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
