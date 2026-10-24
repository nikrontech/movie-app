import 'package:dart_date/dart_date.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/showing.dart';
import 'package:movie_app/style.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowingList extends StatelessWidget {
  final List<Showing> showings;
  final DateTime selectedDate;

  const ShowingList({
    Key? key,
    required this.showings,
    required this.selectedDate,
  }) : super(key: key);

  Future<void> _openBooking(BuildContext context, Uri uri) async {
    var opened = false;
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Report launch failures in the same way as an unsupported URL.
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppText.bookingFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = showings
        .where((showing) => showing.date.toLocal().isSameDay(selectedDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final cinemas = <String, List<Showing>>{};
    for (final showing in selected) {
      final name = showing.cinemaName.trim();
      cinemas
          .putIfAbsent(name.isEmpty ? AppText.cinema : name, () => [])
          .add(showing);
    }
    final now = DateTime.now();
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.showings,
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(formatDate(selectedDate, [yyyy, '-', mm, '-', dd]),
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
          const SizedBox(height: 16),
          if (cinemas.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Style.padding),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Style.borderColor),
                borderRadius: BorderRadius.circular(Style.border),
              ),
              child: Column(children: [
                const Icon(Icons.event_busy_outlined, size: 32),
                const SizedBox(height: 12),
                Text(AppText.noShowings,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
              ]),
            ),
          for (final cinema in cinemas.entries)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Style.borderColor),
                borderRadius: BorderRadius.circular(Style.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cinema.key,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: cinema.value.map((showing) {
                      final time =
                          formatDate(showing.date.toLocal(), [HH, ':', nn]);
                      final started = showing.date.isBefore(now);
                      final uri = Uri.tryParse(showing.ticketLink.trim());
                      final canBook = !started &&
                          uri != null &&
                          (uri.scheme == 'https' || uri.scheme == 'http') &&
                          uri.host.isNotEmpty;
                      final label = Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(time),
                        ],
                      );
                      if (canBook && uri != null) {
                        return OutlinedButton(
                          onPressed: () => _openBooking(context, uri),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            minimumSize: const Size(96, 48),
                            fixedSize: const Size(96, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            side: const BorderSide(color: Style.borderColor),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Style.border)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              label,
                              const SizedBox(width: 6),
                              const Icon(Icons.open_in_new, size: 14),
                            ]),
                          ),
                        );
                      }
                      return SizedBox(
                        width: 96,
                        height: 48,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(Style.border),
                          ),
                          child: DefaultTextStyle.merge(
                            style: TextStyle(
                                color: started ? Colors.black54 : Colors.black),
                            child: label,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
