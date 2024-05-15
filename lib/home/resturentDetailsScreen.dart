import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
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
  ResturentDetailsScreen({super.key,required this.name,required this.desc,required this.rating,required this.openingTime,required this.closingTime,
    required this.address,required this.image,});

  @override
  State<ResturentDetailsScreen> createState() => _ResturentDetailsScreenState();
}

class _ResturentDetailsScreenState extends State<ResturentDetailsScreen> {

  final serviceController = Get.put(ServiceController());


  Future<void> _launchMap(double lat, double lng) async {
    final currentLat = serviceController.currentlat;
    final currentLng = serviceController.currentlong;

    // Clear previous values
    serviceController.resturentLat = 0.0;
    serviceController.resturentlong = 0.0;

    // Set new values
    serviceController.resturentLat = lat;
    serviceController.resturentlong = lng;

    log(currentLat.toString());
    log(currentLng.toString());
    log(serviceController.resturentLat.toString());
    log(serviceController.resturentlong.toString());

    final url = 'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$lat,$lng&travelmode=driving';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? ""),
        leading: GestureDetector(
          onTap: (){
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.mainColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                widget.image,height: 250,width: Get.width,fit: BoxFit.cover,),
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: AppTheme.buttonColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   Text(
                    widget.desc,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                  const SizedBox(
                    height: 10,
                  ),
                   Text(
                     'Rating : - ${widget.rating}',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Opening Time: ${widget.openingTime != null ? '- ${widget.openingTime}' : 'Not Available'}',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.closingTime,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.blackColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () {
                        _launchMap(serviceController.resturentLat, serviceController.resturentlong);
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.mainColor,
                          ),
                          child: Text(
                            'Get Directions',
                            style: TextStyle(color: Colors.white),
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
