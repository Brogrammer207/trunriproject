import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trunriproject/events/postEventScreen.dart';

class EventDiscoveryScreen extends StatefulWidget {
  @override
  State<EventDiscoveryScreen> createState() => _EventDiscoveryScreenState();
}

class _EventDiscoveryScreenState extends State<EventDiscoveryScreen> {
  final List<String> categories = [
    'Music', 'Traditional', 'Business', 'Community & Culture', 'Health & Fitness', 'Fashion'
  ];

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Filter Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField(
                items: categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(),
                onChanged: (value) {},
                decoration: InputDecoration(labelText: 'Category'),
              ),
              RangeSlider(
                values: RangeValues(0, 5000),
                min: 0,
                max: 5000,
                divisions: 10,
                labels: RangeLabels('₹0', '₹5000'),
                onChanged: (values) {},
              ),
              DropdownButtonFormField(
                items: ['Online', 'Offline', 'Free', 'Paid']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {

                },
                decoration: InputDecoration(labelText: 'Event Type'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(categories[index]),
                    backgroundColor: Colors.blue.shade100,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('MakeEvent').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No events available"));
                }
                var events = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    var event = events[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          event['photo'].isNotEmpty ?
                               Image.network( event['photo'][0] , height: 150, width: double.infinity, fit: BoxFit.cover)
                              : Image.asset("assets/images/singing.jpeg", height: 150, width: double.infinity, fit: BoxFit.cover),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event['eventName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text("${event['eventDate']} at ${event['eventTime']}"),
                                Text(event['location'], style: TextStyle(color: Colors.blue)),
                                Text('Price: ${event['ticketPrice']}', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(PostEventScreen());
        },
        child: Icon(Icons.add),
        tooltip: "Post Your Event",
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventTime;
  final String location;
  final String price;
  final String imageUrl;

  EventCard({
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageUrl.isNotEmpty
              ? Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover)
              : Image.asset("assets/images/singing.jpeg", height: 150, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eventName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("$eventDate at $eventTime"),
                Text(location, style: TextStyle(color: Colors.blue)),
                Text('Price: ₹$price', style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}
