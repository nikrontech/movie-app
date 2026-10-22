import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/cinema.dart';
import 'package:movie_app/pages/cinema_page.dart';
import 'package:movie_app/providers/api.dart';

import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/film_card.dart';

class CinemaList extends StatelessWidget {
  final Cinema cinema;
  final bool showRating;
  final bool showShowingTime;
  final bool showTitle;

  const CinemaList({
    Key? key,
    required this.cinema,
    this.showRating = false,
    this.showShowingTime = false,
    this.showTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              InkWell(
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CinemaPage(
                        title: cinema.name,
                        schedule: Api.fetchSchedule(
                          dateFrom: DateTime.now(),
                          dateTo: DateTime.now().addDays(7).endOfDay,
                        ),
                      ),
                    ),
                  ),
                },
                child: Hero(
                  tag: UniqueKey(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              left: Style.padding,
                            ),
                            child: Center(
                              child: Text(
                                cinema.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: Style.padding,
                        ),
                        child: Icon(
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Icons.arrow_forward_ios
                              : Icons.arrow_forward,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: cinema.films.length,
                  itemBuilder: (context, i) {
                    return Container(
                      width: 120,
                      margin: EdgeInsets.only(
                        left: i == 0 ? Style.margin : 2,
                        right: i == cinema.films.length - 1 ? Style.margin : 2,
                      ),
                      child: FilmCard(
                        film: cinema.films[i],
                        showRating: showRating,
                        showShowingTime: showShowingTime,
                        showTitle: showTitle,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        childCount: 1,
      ),
    );
  }
}
