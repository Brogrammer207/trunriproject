import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trunriproject/widgets/appTheme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Controller.dart';

class ResturentDetailsScreen extends StatefulWidget {
  String name;
  String rating;
  String desc;
  String openingTime;
  String closingTime;
  String address;
  String image;
  ResturentDetailsScreen({
    super.key,
    required this.name,
    required this.desc,
    required this.rating,
    required this.openingTime,
    required this.closingTime,
    required this.address,
    required this.image,
  });

  @override
  State<ResturentDetailsScreen> createState() => _ResturentDetailsScreenState();
}

class _ResturentDetailsScreenState extends State<ResturentDetailsScreen> {
  final serviceController = Get.put(ServiceController());

  double resturentLat = 0.0;
  double resturentlong = 0.0;
  Future<void> _launchMap(double lat, double lng) async {
    final currentLat = serviceController.currentlat;
    final currentLng = serviceController.currentlong;

    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$lat,$lng&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    resturentLat = Get.arguments[0];
    resturentlong = Get.arguments[1];

  }
  Future<File> _downloadImage(String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/temp_image.jpg';
    final response = await Dio().download(url, filePath);
    return File(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ""),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.mainColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                final file = await _downloadImage(widget.image);
                String textSend = '${widget.name}    ' + 'Address :- ${widget.address}';
                await Share.shareXFiles(
                  [
                    XFile(file.path),
                  ],
                  text: textSend,
                  subject: widget.address
                );
              } catch (e) {
                log('Error sharing image: $e');
              }
            },
              child: const Icon(Icons.share,color: AppTheme.mainColor,)),
          const SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.image,
                  height: 250,
                  width: Get.width,
                  fit: BoxFit.cover,
                ),

                Positioned(
                  bottom: 10,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ),
              ],

            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: AppTheme.buttonColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                            ),

                            Text(
                              widget.address,
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: AppTheme.blackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            RatingBarIndicator(
                              rating: double.parse(widget.rating), // Set the rating dynamically
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 30.0,
                              direction: Axis.horizontal,
                            ),
                            SizedBox(height: 5,),
                            Text(
                              'Rating : - ${widget.rating}',
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: AppTheme.blackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Opening Time',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                            ),

                            Text(
                              ' ${widget.openingTime.isNotEmpty ? '- ${widget.openingTime}' : 'Not Available'}',
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: AppTheme.blackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(height: 1,color: Colors.grey,),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time_filled),
                      const SizedBox(width: 20,),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Closing Time',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                            ),

                            Text(
                              widget.closingTime,
                              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: AppTheme.blackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(height: 1,color: Colors.grey,),

                  const SizedBox(
                    height: 10,
                  ),

              Container(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(resturentLat, resturentlong),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('resturentLocation'),
                      position: LatLng(resturentLat, resturentlong),
                    ),
                  },
                ),
              ),
                  SizedBox(height: 20,),
                  // InkWell(
                  //     onTap: () {
                  //       _launchMap(serviceController.resturentLat, serviceController.resturentlong);
                  //     },
                  //     child: Container(
                  //         padding: EdgeInsets.all(10),
                  //         decoration: BoxDecoration(
                  //           color: AppTheme.mainColor,
                  //         ),
                  //         child: Text(
                  //           'Get Directions',
                  //           style: TextStyle(color: Colors.white),
                  //         )))
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchMap(resturentLat, resturentlong);
        },
        child: const Icon(Icons.directions),
        backgroundColor: AppTheme.mainColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Position the FAB at the bottom right
    );
  }
}
