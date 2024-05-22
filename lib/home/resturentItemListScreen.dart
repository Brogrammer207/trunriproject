import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/resturentDetailsScreen.dart';
import 'package:http/http.dart' as http;
import 'package:trunriproject/home/search_field.dart';
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
  final apiKey = 'AIzaSyAP9njE_z7lH2tii68WLoQGju0DF8KryXA'; // Replace with your API key
  final serviceController = Get.put(ServiceController());

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(child: SearchField()),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Resturent List',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _restaurants.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index) {
                final restaurant = _restaurants[index];
                final name = restaurant['name'];
                final address = restaurant['vicinity'];
                final rating = (restaurant['rating'] as num?)?.toDouble() ?? 0.0;
                final reviews = restaurant['reviews'];
                final description = restaurant['description'] ?? 'No Description Available';
                final openingHours =
                    restaurant['opening_hours'] != null ? restaurant['opening_hours']['weekday_text'] : 'Not Available';
                final closingTime = restaurant['closing_time'] ?? 'Not Available';
                final photoReference = restaurant['photos'] != null ? restaurant['photos'][0]['photo_reference'] : null;
                final photoUrl = photoReference != null
                    ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
                    : null;
                final lat = restaurant['geometry']['location']['lat'];
                final lng = restaurant['geometry']['location']['lng'];

                resturentLat = lat.toString();
                resturentlong = lng.toString();

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
                            child: Image.network(
                              photoUrl,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
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
