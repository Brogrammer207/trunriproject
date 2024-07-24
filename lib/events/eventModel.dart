class Event {
  final String name;
  final String description;
  final DateTime startTime;
  final DateTime endTime;

  Event({
    required this.name,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name']['text'] ?? 'No name',
      description: json['description']['text'] ?? 'No description',
      startTime: DateTime.parse(json['start']['utc']),
      endTime: DateTime.parse(json['end']['utc']),
    );
  }
}
