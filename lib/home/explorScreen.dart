import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExplorScreen extends StatefulWidget {
  const ExplorScreen({super.key});

  @override
  State<ExplorScreen> createState() => _ExplorScreenState();
}

class _ExplorScreenState extends State<ExplorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Items'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ListTile(
              leading: Image.asset('assets/images/restaurent.png'),
              title: Text('Restaurant'),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              leading: Image.asset('assets/images/store.png'),
              title: Text('Grocery Stores'),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              leading: Image.asset('assets/images/accommodation.png'),
              title: Text('Accommodation'),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
            Divider(
              height: 10,
            ),
            ListTile(
              leading: Image.asset('assets/images/events.png'),
              title: Text('Events'),
              trailing: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
