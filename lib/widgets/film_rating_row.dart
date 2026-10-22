import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/rating.dart';
import 'package:movie_app/style.dart';

class FilmRatingRow extends StatelessWidget {
  final Rating rating;

  const FilmRatingRow({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: Style.padding / 4,
          ),
          child: SvgPicture.asset(
            "assets/imdb.svg",
            height: 35,
          ),
        ),
        Text(
          rating.imdb ?? AppText.dash,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: Style.padding / 4,
            left: Style.padding / 2,
          ),
          child: SvgPicture.asset(
            "assets/rotten_tomatoes.svg",
            height: 20,
          ),
        ),
        Text(
          rating.rottenTomatoes ?? AppText.dash,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: Style.padding / 4,
            left: Style.padding / 2,
          ),
          child: SvgPicture.asset(
            "assets/metacritic.svg",
            height: 20,
          ),
        ),
        Text(
          rating.metaScore ?? AppText.dash,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
