import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/providers/api.dart';
import 'package:movie_app/style.dart';

class Thumbnail extends StatelessWidget {
  final String filename;
  final double border;

  const Thumbnail({
    Key? key,
    required this.filename,
    this.border = Style.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(border)),
      child: filename.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: Api.getImageUrl(filename),
              fit: BoxFit.fill,
            )
          : ColoredBox(
              color: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.movie,
                size: Style.iconSize,
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
