import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notificatioonscreen extends StatefulWidget {
  const Notificatioonscreen({super.key});

  @override
  State<Notificatioonscreen> createState() => _NotificatioonscreenState();
}

class _NotificatioonscreenState extends State<Notificatioonscreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Text("Notification Screen"))
          ],
        ),
      ),
    );
  }
}
