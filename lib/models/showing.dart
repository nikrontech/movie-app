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
}
