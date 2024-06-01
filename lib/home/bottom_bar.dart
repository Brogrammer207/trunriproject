import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/profile/profileScreen.dart';
import 'addAccommodationScreen.dart';
import 'explorScreen.dart';
import 'favoriteRestaurantsScreen.dart';
import 'home_screen.dart';

class MyBottomNavBar extends StatefulWidget {
  const MyBottomNavBar({super.key});

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int myCurrentIndex = 0;
  List pages = [
    const HomeScreen(),
    FavoriteRestaurantsScreen(),
    const ExplorScreen(),
    const ProfileScreen(),
  ];



  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.redAccent,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                selectedItemColor: Colors.redAccent,
                unselectedItemColor: Colors.black,
                currentIndex: myCurrentIndex,
                onTap: (index) {
                  setState(() {
                    myCurrentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
                  BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Discover"),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
                ],
              ),
            ),
          ),
        ),
      ),
      body: pages[myCurrentIndex],
    );
  }
}
