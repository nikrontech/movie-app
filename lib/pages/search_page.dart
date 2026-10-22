import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/cinema.dart';
import 'package:movie_app/models/schedule.dart';
import 'package:movie_app/providers/api.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/cinema_list.dart';
import 'package:movie_app/widgets/sliver_search_bar.dart';

class SearchPage extends StatefulWidget {
  final Future<Schedule> schedule;
  final String searchText;

  const SearchPage({
    Key? key,
    required this.schedule,
    required this.searchText,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState(schedule, searchText);
}

class _SearchPageState extends State<SearchPage> {
  late Future<Schedule> schedule;
  late String searchText;

  _SearchPageState(this.schedule, this.searchText);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: FutureBuilder<Schedule>(
          future: schedule,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Cinema> cinemas = snapshot.data!.cinemas;

              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverSearchBar(
                    onSubmitted: (String searchText) {
                      setState(() {
                        schedule = Api.fetchSchedule(
                          dateFrom: DateTime.now(),
                          dateTo: DateTime.now().addDays(7).endOfDay,
                          searchText: searchText,
                        );
                        this.searchText = searchText;
                      });
                    },
                    autofocus: false,
                    placeholder: searchText,
                    alwaysOpen: true,
                  ),
                  const SliverPadding(
                    padding: EdgeInsets.only(
                      top: Style.padding,
                    ),
                  ),
                  if (cinemas.isNotEmpty) ...[
                    for (Cinema cinema in cinemas) ...[
                      CinemaList(
                        cinema: cinema,
                        showTitle: true,
                      )
                    ],
                  ] else ...[
                    SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.all(Style.padding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.search,
                              size: Style.iconSize,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Style.padding,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      text: '${AppText.noResults} ',
                                    ),
                                    TextSpan(
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      text: searchText.trim(),
                                    ),
                                    TextSpan(
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      text: AppText.dot,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
