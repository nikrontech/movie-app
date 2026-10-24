import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/pages/film_page.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/thumbnail.dart';

class FilmCard extends StatelessWidget {
  final Film film;
  final double border;
  final bool showRating;
  final bool showShowingTime;
  final bool showTitle;
  final DateTime? selectedDate;
  final bool selectedNow;

  const FilmCard({
    Key? key,
    required this.film,
    this.border = Style.border,
    this.showRating = false,
    this.showShowingTime = false,
    this.showTitle = false,
    this.selectedDate,
    this.selectedNow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(border),
        ),
      ),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => FilmPage(
                film: film,
                selectedDate: selectedDate,
                selectedNow: selectedNow,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.all(Radius.circular(border)),
        child: Hero(
          tag: UniqueKey(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Thumbnail(
                  border: border,
                  filename: film.thumbnail,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (showTitle) ...[
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              film.title,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    Row(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (showRating && film.rating.imdb != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 5,
                                ),
                                child: SvgPicture.asset(
                                  "assets/imdb.svg",
                                  height: 25,
                                ),
                              ),
                              Text(
                                film.rating.imdb ?? '',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                            if (showShowingTime) ...[
                              Text(
                                formatDate(
                                  film.showings[0].date,
                                  [HH, ':', nn],
                                ),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
