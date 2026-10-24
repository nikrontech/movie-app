import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/showing.dart';
import 'package:movie_app/widgets/showing_list.dart';

void main() {
  final day = DateTime(2099, 1, 10);

  Widget listing(List<Showing> showings) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ShowingList(showings: showings, selectedDate: day),
          ),
        ),
      );

  testWidgets('Filters the local date and groups formats with booking actions',
      (tester) async {
    await tester.pumpWidget(listing([
      Showing(
          date: day.add(const Duration(hours: 20)),
          cinemaName: 'Cinema A',
          screenType: 'IMAX',
          ticketLink: 'https://example.com/tickets'),
      Showing(
          date: day.add(const Duration(hours: 14)),
          cinemaName: 'Cinema A',
          screenType: '2D'),
      Showing(date: day.add(const Duration(days: 1)), cinemaName: 'Other day'),
    ]));
    expect(find.text('Cinema A'), findsOneWidget);
    expect(find.text('Other day'), findsNothing);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(tester.getTopLeft(find.text('14:00')).dy,
        lessThan(tester.getTopLeft(find.text('20:00')).dy));
  });

  testWidgets('Empty date provides a next step', (tester) async {
    await tester.pumpWidget(listing([]));
    expect(find.text(AppText.noShowings), findsOneWidget);
  });

  testWidgets('Invalid booking links remain informational', (tester) async {
    await tester.pumpWidget(listing([
      Showing(date: day, ticketLink: 'javascript:alert(1)'),
    ]));
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.text(AppText.cinema), findsOneWidget);
  });

  testWidgets('Long cinema names and enlarged text fit a narrow viewport',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Scaffold(
            body: SingleChildScrollView(
                child: ShowingList(
          selectedDate: day,
          showings: [
            Showing(
                date: day,
                cinemaName: 'Ilgas kino teatro pavadinimas',
                ticketLink: 'https://example.com')
          ],
        ))),
      ),
    ));
    expect(tester.takeException(), isNull);
  });
}
