import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:trunriproject/home/product.dart';
import 'package:trunriproject/home/product_cart.dart';
import 'package:trunriproject/widgets/helper.dart';
import '../model/bannerModel.dart';
import '../model/categoryModel.dart';
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
    List<String> imageUrls = [];
    Future<List<String>> fetchImageData() async {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('banners').get();

        querySnapshot.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String imageUrl = data['imageUrl'];
          imageUrls.add(imageUrl);
        });
      } catch (e) {
        print("Error fetching image data: $e");
      }

      return imageUrls;
    }

    RxDouble sliderIndex = (0.0).obs;
    @override
    void initState() {
      super.initState();
      fetchImageData();
    }

    int currentIndex = 0;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('banners').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching products'),
                    );
                  }

                  List<BannerModel> banner = snapshot.data!.docs.map((doc) {
                    return BannerModel.fromMap(doc.id, doc.data());
                  }).toList();

                  return Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: (value, _) {
                              sliderIndex.value = value.toDouble();
                            },
                            autoPlayCurve: Curves.ease,
                            height: height * .20),
                        items: List.generate(
                            banner.length,
                            (index) => Container(
                                width: width,
                                margin: EdgeInsets.symmetric(horizontal: width * .01),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.grey),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: banner[index].imageUrl,
                                    errorWidget: (_, __, ___) => const SizedBox(),
                                    placeholder: (_, __) => const SizedBox(),
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                      ),
                    ],
                  );
                },
              ),
              DotsIndicator(
                dotsCount: 3,
                position: currentIndex.round(),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error fetching products'),
                      );
                    }

                    List<Category> category = snapshot.data!.docs.map((doc) {
                      return Category.fromMap(doc.id, doc.data());
                    }).toList();
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // padEnds: false,
                        // controller: PageController(viewportFraction: .2),
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                // Get.to(() => CategoryScreen(
                                //       keyId: category[index].name,
                                //     ));
                              },
                              child:
                                  CategoryCard(icon: category[index].imageUrl, text: category[index].name, press: () {})
                              // Container(
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(12),
                              //       border: Border.all(color: Colors.transparent, width: 2)),
                              //   margin: const EdgeInsets.symmetric(horizontal: 10),
                              //   padding: const EdgeInsets.symmetric(horizontal: 6),
                              //   constraints: BoxConstraints(maxWidth: context.getSize.width * .16),
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: [
                              //       CircleAvatar(
                              //         radius: 30, // Image radius
                              //         backgroundImage: NetworkImage(category[index].imageUrl),
                              //       ),
                              //       const SizedBox(
                              //         height: 7,
                              //       ),
                              //       Center(
                              //         child: Text(
                              //           category[index].name.capitalize!,
                              //           overflow: TextOverflow.ellipsis,
                              //           maxLines: 1,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              );
                        });
                  },
                ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(icon),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 4), // Add space between the image and the text
            Container(
              width: 56, // Adjust width if needed
              child: Text(
                text.capitalize!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12, // Adjust the font size as needed
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Allow text to wrap to 2 lines if needed
              ),
            ),
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
