class Showing {
  final DateTime date;
  final String screenType;
  final String ticketLink;

  Showing({this.date, this.screenType, this.ticketLink});

  factory Showing.fromJson(Map<String, dynamic> json) {
    return Showing(
      date: DateTime.parse(json['date']),
      screenType: json['screenType'],
      ticketLink: json['ticketLink'],
    );
  }
}
