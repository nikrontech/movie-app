import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/app_text.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/utils/html_text.dart';

class FilmDescription extends StatefulWidget {
  final Film film;

  const FilmDescription({Key? key, required this.film}) : super(key: key);

  @override
  _FilmDescriptionState createState() => _FilmDescriptionState(film);
}

class _FilmDescriptionState extends State<FilmDescription> {
  final Film film;
  bool showFullDescription = false;

  _FilmDescriptionState(this.film);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AutoSizeText.rich(
        TextSpan(
          children: <TextSpan>[
            synopsisSpan(film.synopsis),
            if (film.cast.isNotEmpty) ...[
              const TextSpan(
                text: '\n\n${AppText.starring} ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: film.cast),
            ],
            if (film.director.isNotEmpty) ...[
              const TextSpan(
                text: '\n\n${AppText.directedBy} ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: film.director),
            ],
          ],
        ),
        maxLines: 3,
        minFontSize: 15,
        maxFontSize: 15,
        overflowReplacement: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                maxLines: showFullDescription ? null : 3,
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  children: <TextSpan>[
                    synopsisSpan(film.synopsis),
                    if (showFullDescription) ...[
                      if (film.genre.isNotEmpty) ...[
                        const TextSpan(
                          text: '\n\n${AppText.genre} ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: film.genre),
                      ],
                      if (film.cast.isNotEmpty) ...[
                        const TextSpan(
                          text: '\n\n${AppText.starring} ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: film.cast),
                      ],
                      if (film.director.isNotEmpty) ...[
                        const TextSpan(
                          text: '\n\n${AppText.directedBy} ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: film.director),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                // backgroundColor: Colors.black12,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Style.border),
                ),
              ),
              child: Icon(
                showFullDescription ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () =>
                  setState(() => showFullDescription = !showFullDescription),
            ),
          ],
        ),
      ),
    );
  }
}
