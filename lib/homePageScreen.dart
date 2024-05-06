import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trunriproject/widgets/appTheme.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final items = [
    Image.asset('assets/images/banner.jpeg'),
    Image.asset('assets/images/bannertwo.jpeg'),
    Image.asset('assets/images/bannerthree.jpeg'),
  ];

  int currentIndex = 0;

  var _bottomNavIndex = 0;
  final iconList = <IconData>[
    Icons.brightness_5,
    Icons.brightness_4,
    Icons.brightness_6,
    Icons.brightness_7,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.buttonColor,
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.center,
          backgroundColor: const Color(0xffFF730A),
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
          tabBuilder: (int index, bool isActive) {
            return Icon(
              iconList[index],
              size: 24,
              color: isActive ? Colors.grey : Colors.white,
            );
          }),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 45,
          width: 400,
          child: TextField(
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffFF730A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: "Search here ....",
              hintStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  decorationThickness: 6),
              suffixIcon: const Icon(Icons.search),
              suffixIconColor: Colors.white,
            ),
          ),
        ),
        actions: const [
          Icon(
            Icons.notifications_none,
            size: 30,
            color: Color(0xffFF730A),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              items: items,
            ),
            DotsIndicator(
              dotsCount: items.length,
              position: currentIndex.round(),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.menu)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 35,
                              minRadius: 35,
                              child: Icon(
                                Icons.ac_unit,
                                size: 30,
                              ),
                            ),
                            Text('Temples')
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 35,
                              minRadius: 35,
                              child: Icon(
                                Icons.ac_unit,
                                size: 30,
                              ),
                            ),
                            Text('Temples')
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 35,
                              minRadius: 35,
                              child: Icon(
                                Icons.ac_unit,
                                size: 30,
                              ),
                            ),
                            Text('Temples')
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 35,
                              minRadius: 35,
                              child: Icon(
                                Icons.ac_unit,
                                size: 30,
                              ),
                            ),
                            Text('Temples')
                          ],
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            CircleAvatar(
                              maxRadius: 35,
                              minRadius: 35,
                              child: Icon(
                                Icons.ac_unit,
                                size: 30,
                              ),
                            ),
                            Text('Temples')
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Category",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.menu)
                    ],
                  ),
              Container(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    _buildImage('assets/images/nature.jpeg'),
                    _buildImage('assets/images/nature.jpeg'),
                    _buildImage('assets/images/nature.jpeg'),
                    _buildImage('assets/images/nature.jpeg'),
                    _buildImage('assets/images/nature.jpeg'),
                  ],
                ),
              ),
                  const SizedBox(height: 20,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming Events",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.menu)
                    ],
                  ),
                  Container(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Restaurants",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.menu)
                    ],
                  ),
                  Container(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Accommodation",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      Icon(Icons.menu)
                    ],
                  ),
                  Container(
                    height: 130,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                        _buildImage('assets/images/nature.jpeg'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildImage(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.asset(
          imagePath,
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
