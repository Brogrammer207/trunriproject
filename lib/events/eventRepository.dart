import 'dart:convert';
import 'package:http/http.dart' as http;

import 'eventModel.dart';

class EventRepository {
  final String apiUrl = 'https://www.eventbriteapi.com/v3/events/search/';
  final String privateToken = '45IO2GHLIDTHYCMHFVIH';

  Future<List<Event>> fetchEvents() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $privateToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List eventsJson = json['events'];
      return eventsJson.map((json) => Event.fromJson(json)).toList();
    } else {
      print('Failed to load events. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load events');
    }
  }
}
