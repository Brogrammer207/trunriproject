import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/resturentDetailsScreen.dart';

class FavoriteRestaurantsScreen extends StatefulWidget {
  @override
  _FavoriteRestaurantsScreenState createState() => _FavoriteRestaurantsScreenState();
}

class _FavoriteRestaurantsScreenState extends State<FavoriteRestaurantsScreen> {
  Future<List<FavoriteRestaurant>> _fetchFavorites() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return [];
    }

    final snapshot =
        await FirebaseFirestore.instance.collection('favorite').doc(userId).collection('restaurants').get();

    return snapshot.docs.map((doc) => FavoriteRestaurant.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Restaurants'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<FavoriteRestaurant>>(
        future: _fetchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite restaurants found.'));
          }

          final favoriteRestaurants = snapshot.data!;

          return Container(
            decoration: const BoxDecoration(
              // color: Color(0xFFF2EDE2)
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color(0xffF4EEF2),
                  Color(0xffF4EEF2),
                  Color(0xffE3EDF5),
                ],
              ),
            ),
            child: ListView.builder(
              itemCount: favoriteRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = favoriteRestaurants[index];
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(bottom: 8, left: 10, top: 2),
                      decoration: BoxDecoration(color: const Color(0xfff1cbe2), borderRadius: BorderRadius.circular(5)),
                      child: Image.network(
                        restaurant.image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Get.to(
                              ResturentDetailsScreen(
                                  name: restaurant.name,
                                  desc: restaurant.desc,
                                  rating: restaurant.rating,
                                  openingTime: restaurant.opentime,
                                  closingTime: restaurant.closetime,
                                  address: restaurant.address,
                                  image: restaurant.image));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            Text(restaurant.address)
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FavoriteRestaurant {
  final String name;
  final String address;
  final String image;
  final String desc;
  final String rating;
  final String opentime;
  final String closetime;

  FavoriteRestaurant({required this.name, required this.address, required this.image,required this.rating, required this.opentime, required this.closetime,required this.desc,});

  factory FavoriteRestaurant.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return FavoriteRestaurant(
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      image: data['image'] ?? '',
      desc: data['desc'] ?? '',
      rating: data['rating'] ?? '',
      opentime: data['opentime'] ?? '',
      closetime: data['closetime'] ?? '',
    );
  }
}
