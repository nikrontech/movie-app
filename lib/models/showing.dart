class Showing {
  final DateTime date;
  final String cinemaName;
  final String screenType;
  final String ticketLink;

  Showing({
    required this.date,
    this.cinemaName = '',
    this.screenType = '',
    this.ticketLink = '',
  });

  factory Showing.fromJson(Map<String, dynamic> json) {
    return Showing(
      date: DateTime.parse(json['date'] as String),
      cinemaName: json['cinemaName'] as String? ?? '',
      screenType: json['screenType'] as String? ?? '',
      ticketLink: json['ticketLink'] as String? ?? '',
    );
  }

  factory Showing.fromBackendJson(Map<String, dynamic> json) {
    final start = json['startsAt'] as String?;
    final format = json['format']?.toString() ?? '';
    final screen = json['screen']?.toString() ?? '';
    final screenLabel = format.isNotEmpty
        ? format
        : RegExp(r'^[0-9a-f]{8}-[0-9a-f-]{27}$', caseSensitive: false)
                .hasMatch(screen)
            ? ''
            : screen;
    final cinema = json['cinema'];

    return Showing(
      date: start == null
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : DateTime.parse(start),
      cinemaName: cinema is Map<String, dynamic>
          ? cinema['name']?.toString() ?? ''
          : '',
      screenType: screenLabel,
      ticketLink: json['bookingUrl'] as String? ?? '',
    );
  }
}
