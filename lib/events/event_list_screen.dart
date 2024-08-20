import 'package:flutter/material.dart';

import 'eventModel.dart';
import 'eventRepository.dart';




class EventListScreen extends StatelessWidget {
  final EventService eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organizations"),
      ),
      body: FutureBuilder<EventsModel?>(
        future: eventService.fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final organizations = snapshot.data?.organizations;
            if (organizations == null || organizations.isEmpty) {
              return Center(child: Text("No organizations found."));
            } else {
              return ListView.builder(
                itemCount: organizations.length,
                itemBuilder: (context, index) {
                  final organization = organizations[index];
                  return ListTile(
                    title: Text(organization.name ?? "No Name"),
                    subtitle: Text(organization.id ?? "No Vertical"),
                  );
                },
              );
            }
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
