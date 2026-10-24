import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/schedule.dart';
import 'package:movie_app/pages/search_page.dart';
import 'package:movie_app/providers/api.dart';
import 'package:movie_app/services/location_service.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/film_grid.dart';
import 'package:movie_app/widgets/sliver_search_bar.dart';
import 'package:movie_app/widgets/week_button_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late Future<Schedule> schedule;
  DateTime selectedDate = DateTime.now();
  bool selectedNow = false;

  @override
  void initState() {
    schedule = _loadInitialSchedule();
    super.initState();
  }

  Future<Schedule> _loadInitialSchedule() async {
    await LocationService.fetchLocation();
    return await Api.fetchSchedule(dateFrom: selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: WeekButtonList(
                  initialDate: selectedDate,
                  margin: const EdgeInsets.only(
                    left: Style.margin,
                    right: Style.margin,
                  ),
                  onChanged: (DateTime dateSelected) {
                    setState(() {
                      selectedDate = dateSelected;
                      selectedNow = false;
                      schedule = Api.fetchSchedule(
                        dateFrom: dateSelected,
                      );
                    });
                  },
                  onNowPressed: () {
                    final now = DateTime.now();
                    setState(() {
                      selectedDate = now;
                      selectedNow = true;
                      schedule = Api.fetchSchedule(
                        dateFrom: now,
                        dateTo: now.add(const Duration(hours: 2)),
                      );
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        body: Material(
          color: Theme.of(context).primaryColor,
          child: FutureBuilder<Schedule>(
            future: schedule,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Style.padding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_off_outlined,
                          size: Style.iconSize,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: Style.padding),
                        Text(
                          AppText.loadFailed,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                final films = snapshot.data!.films;

                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: <Widget>[
                    SliverSearchBar(
                      onSearchPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchPage(
                              searchText: '',
                              schedule: Api.fetchSchedule(
                                dateFrom: DateTime.now(),
                                dateTo: DateTime.now().addDays(6).endOfDay,
                              ),
                            ),
                          ),
                        );
                      },
                      onSubmitted: (String searchText) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => SearchPage(
                              searchText: searchText,
                              schedule: Api.fetchSchedule(
                                dateFrom: DateTime.now(),
                                dateTo: DateTime.now().addDays(6).endOfDay,
                                searchText: searchText,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(
                        top: Style.padding,
                      ),
                    ),
                    if (films.isNotEmpty) ...[
                      FilmGrid(
                        films: films,
                        selectedDate: selectedDate,
                        selectedNow: selectedNow,
                      ),
                    ] else ...[
                      SliverFillRemaining(
                        child: Padding(
                          padding: const EdgeInsets.all(Style.padding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.movie,
                                size: Style.iconSize,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: Style.padding,
                                ),
                                child: Text(
                                  AppText.noMovies,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
      ),
    );
  }
}
