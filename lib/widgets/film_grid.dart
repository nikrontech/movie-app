import 'package:flutter/material.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/film_card.dart';

class FilmGrid extends StatelessWidget {
  final List<Film> films;
  final DateTime? selectedDate;
  final bool selectedNow;

  const FilmGrid({
    Key? key,
    required this.films,
    this.selectedDate,
    this.selectedNow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: Style.padding),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: Style.padding,
          childAspectRatio: 0.53,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FilmCard(
            film: films[index],
            selectedDate: selectedDate,
            selectedNow: selectedNow,
            showTitle: true,
          ),
          childCount: films.length,
        ),
      ),
    );
  }
}
