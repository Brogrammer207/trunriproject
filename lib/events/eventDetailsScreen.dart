import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {

  String? photo;
  String? eventName;
  String? eventDate;
  String? eventTime;
  String? location;
  String? Price;

   EventDetailsScreen({super.key,this.eventDate,this.eventName,this.eventTime,this.location,this.photo,this.Price});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:Column(
          children: [
          Card(
          color: Colors.white,
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.photo!.isNotEmpty ?
              Image.network( widget.photo.toString(),fit: BoxFit.fill,width: double.infinity,)
                  : Image.asset("assets/images/singing.jpeg", height: 150, width: double.infinity, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.eventName!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("${widget.eventDate!} at ${widget.eventTime!}"),
                    Text(widget.location!, style: TextStyle(color: Colors.blue)),
                    Text('Price: ${widget.Price!}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: Icon(Icons.bookmark_border), onPressed: () {}),
                        IconButton(icon: Icon(Icons.share), onPressed: () {}),
                        IconButton(icon: Icon(Icons.map), onPressed: () {}),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xffFF730A),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: Text(
                                "Buy Ticket",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
}
