import 'package:flutter/material.dart';
import 'package:movie_app/models/cinema.dart';
import 'package:movie_app/models/schedule.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/film_card.dart';

class CinemaPage extends StatelessWidget {
  final Future<Schedule> schedule;
  final String title;

  const CinemaPage({Key key, @required this.title, @required this.schedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: FutureBuilder<Schedule>(
          future: schedule,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final Cinema cinema = snapshot.data.cinemas
                  .firstWhere((element) => element.name == title);

              return CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverAppBar(
                    title: Text(
                      title,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    floating: true,
                    elevation: Theme.of(context).appBarTheme.elevation,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(Style.padding),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.53,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int i) {
                          return SizedBox(
                            child: FilmCard(
                              film: cinema.films[i],
                              showTitle: true,
                            ),
                          );
                        },
                        childCount: cinema.films.length,
                      ),
                    ),
                  ),
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
