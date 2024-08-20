import 'dart:convert';
import 'package:http/http.dart' as http;

import 'eventModel.dart';

class EventService {
  final String apiUrl = "https://www.eventbriteapi.com/v3/users/me/organizations/";
  final String token = "45IO2GHLIDTHYCMHFVIH"; // Replace with your API token

  Future<EventsModel?> fetchEvents() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return EventsModel.fromJson(json.decode(response.body));
    } else {
      // Handle the error
      print("Failed to load events: ${response.statusCode}");
      return null;
    }
  }
}
