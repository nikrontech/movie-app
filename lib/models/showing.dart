class Showing {
  final DateTime date;
  final String screenType;
  final String ticketLink;

  Showing({required this.date, this.screenType = '', this.ticketLink = ''});

  factory Showing.fromJson(Map<String, dynamic> json) {
    return Showing(
      date: DateTime.parse(json['date'] as String),
      screenType: json['screenType'] as String? ?? '',
      ticketLink: json['ticketLink'] as String? ?? '',
    );
  }

  factory Showing.fromBackendJson(Map<String, dynamic> json) {
    final start = json['startsAt'] as String?;
    final screen = [json['screen'], json['format']]
        .where((value) => value != null && value.toString().isNotEmpty)
        .join(' · ');

    return Showing(
      date: start == null ? DateTime.fromMillisecondsSinceEpoch(0) : DateTime.parse(start),
      screenType: screen,
      ticketLink: json['bookingUrl'] as String? ?? '',
    );
  }
}
