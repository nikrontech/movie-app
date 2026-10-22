import 'package:dart_date/dart_date.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/showing.dart';
import 'package:movie_app/style.dart';

class ShowingList extends StatelessWidget {
  final List<Showing> showings;
  final DateTime selectedDate;

  const ShowingList({
    Key? key,
    required this.showings,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final byCinema = <String, List<Showing>>{};
    final selectedShowings = showings
        .where((showing) => showing.date.toLocal().isSameDay(selectedDate))
        .toList();
    final sortedShowings = [...selectedShowings]
      ..sort((left, right) => left.date.compareTo(right.date));

    for (final showing in sortedShowings) {
      final cinema = showing.cinemaName.isEmpty ? 'Cinema' : showing.cinemaName;
      byCinema.putIfAbsent(cinema, () => []).add(showing);
    }

    final secondary = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < byCinema.entries.length; i++) ...[
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : Style.padding),
              child: Text(
                byCinema.entries.elementAt(i).key,
                style: TextStyle(color: secondary, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: byCinema.entries
                    .elementAt(i)
                    .value
                    .map((showing) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: secondary),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            formatDate(showing.date.toLocal(), [HH, ':', nn]),
                            style: TextStyle(color: secondary),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        if (byCinema.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: Style.padding * 2),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_busy, size: Style.iconSize, color: secondary),
                  const SizedBox(height: Style.padding),
                  Text(
                    AppText.noShowings,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: secondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
