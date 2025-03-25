import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class RestaurantListScreen extends StatefulWidget {
  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  Position? _currentPosition;
  List<dynamic> _restaurants = [];
  final apiKey = 'AIzaSyAP9njE_z7lH2tii68WLoQGju0DF8KryXA';
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }


    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
      _fetchIndianRestaurants(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchIndianRestaurants(double latitude, double longitude) async {
    final australiaLatitude = -33.8688;
    final australiaLongitude = 151.2093;
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$australiaLatitude,$australiaLongitude&radius=1500&type=restaurant&keyword=indian&key=$apiKey';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indian Restaurants Nearby'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator(color: Colors.orange,))
          : ListView.builder(
        itemCount: _restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _restaurants[index];
          final name = restaurant['name'];
          final address = restaurant['vicinity'];
          final rating = restaurant['rating'];
          final photoReference = restaurant['photos'] != null
              ? restaurant['photos'][0]['photo_reference']
              : null;
          final photoUrl = photoReference != null
              ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey'
              : null;

          return Column(
            children: [
              if (rating != null) Text('Rating: $rating'),
            ],
          );

          //   ListTile(
          //   title: Text(name),
          //   subtitle: Text(address),
          //   leading: photoUrl != null ? Image.network(photoUrl,height: 100,width: 100,fit: BoxFit.fill,) : null,
          // );
        },
      ),
    );
  }
}