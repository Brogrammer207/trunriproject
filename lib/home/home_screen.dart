import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trunriproject/home/product.dart';
import 'package:trunriproject/home/product_cart.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import 'section_title.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final items = [
      Image.asset('assets/images/banner.jpeg'),
      Image.asset('assets/images/bannertwo.jpeg'),
      Image.asset('assets/images/bannerthree.jpeg'),
    ];

    int currentIndex = 0;
    List<Map<String, dynamic>> categories = [
      {"icon": "assets/icons/Flash Icon.svg", "text": "temples"},
      {"icon": "assets/icons/Bill Icon.svg", "text": "temples"},
      {"icon": "assets/icons/Game Icon.svg", "text": "temples"},
      {"icon": "assets/icons/Gift Icon.svg", "text": "temples"},
      {"icon": "assets/icons/Discover.svg", "text": "temples"},
    ];
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
                margin: EdgeInsets.only(left: 20),
                height: 100,
                child: ListView.builder(
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return
                        CategoryCard(icon: 'assets/images/apple.png', text: 'Temples', press: (){});
                    }),
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
      child: Expanded(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(16),
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(icon),
            ),
            const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 2, // Allow up to 2 lines of text
              overflow: TextOverflow.ellipsis, // Ellipsis if text overflows
            )
          ],
        ),
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
