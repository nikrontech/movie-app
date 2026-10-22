import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/film.dart';
import 'package:movie_app/models/showing.dart';
import 'package:movie_app/providers/api.dart';
import 'package:movie_app/style.dart';
import 'package:movie_app/widgets/film_description.dart';
import 'package:movie_app/widgets/film_rating_row.dart';
import 'package:movie_app/widgets/thumbnail.dart';
import 'package:movie_app/widgets/video_player.dart';

class FilmPage extends StatefulWidget {
  final Film film;
  final double appBarHeight;

  const FilmPage({Key? key, required this.film, this.appBarHeight = 250})
      : super(key: key);

  @override
  _FilmPageState createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  VideoPlayer? videoPlayer;
  late ScrollController scrollController;
  late ScrollController headerScrollController;
  bool isAppBarTransparent = false;
  late List<String> infoList;

  @override
  void initState() {
    videoPlayer = widget.film.trailer.isNotEmpty
        ? VideoPlayer(url: Api.getVideoUrl(widget.film.trailer))
        : null;
    scrollController = ScrollController();
    headerScrollController = ScrollController();

    scrollController.addListener(() {
      final double offset = scrollController.offset;
      headerScrollController.jumpTo(offset);

      if (!isAppBarTransparent && offset >= 100) {
        setState(() => isAppBarTransparent = true);
      } else if (offset <= 0) {
        setState(() => isAppBarTransparent = false);
      }
    });

    infoList = widget.film.getInfoList();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    headerScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              controller: headerScrollController,
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: widget.appBarHeight,
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: Text(''),
                  ),
                  flexibleSpace: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (widget.film.poster.isNotEmpty) ...[
                        SizedBox(
                          height: widget.appBarHeight,
                          child: CachedNetworkImage(
                            imageUrl: Api.getImageUrl(widget.film.poster),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                      Container(
                        height: widget.appBarHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.3],
                          ),
                        ),
                      ),
                      Container(
                        height: widget.appBarHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Colors.transparent
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: const [0, 0.3],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ],
            ),
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  backgroundColor: isAppBarTransparent
                      ? Theme.of(context).appBarTheme.backgroundColor
                      : Colors.transparent,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: Style.padding,
                      right: Style.padding,
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 285,
                          child: Stack(
                            children: <Widget>[
                              if (videoPlayer != null) ...[
                                SizedBox(
                                  height: 140,
                                  child: Center(
                                    child: IconButton(
                                      icon:
                                          const Icon(Icons.play_circle_filled),
                                      color: Colors.white54,
                                      iconSize: 70,
                                       onPressed: () => videoPlayer!.play(),
                                    ),
                                  ),
                                ),
                              ],
                              Positioned(
                                top: 105,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 120,
                                      height: 180,
                                      child: Thumbnail(
                                        filename: widget.film.thumbnail,
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: 90,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              120 -
                                              2 * Style.padding,
                                          padding: const EdgeInsets.only(
                                            left: Style.padding,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AutoSizeText(
                                                widget.film.title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                maxLines: 2,
                                                presetFontSizes:
                                                    List<double>.generate(
                                                  30,
                                                  (i) => 20.0 - i,
                                                ),
                                              ),
                                              if (widget.film.foreignTitle !=
                                                  null) ...[
                                                AutoSizeText(
                                                  widget.film.foreignTitle,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  maxLines: 1,
                                                  presetFontSizes:
                                                      List<double>.generate(
                                                    15,
                                                    (i) => 15.0 - i,
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 90,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              120 -
                                              2 * Style.padding,
                                          padding: const EdgeInsets.only(
                                            left: Style.padding,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              if (infoList.isNotEmpty) ...[
                                                Row(
                                                  children: <Widget>[
                                                    for (int i = 0;
                                                        i < infoList.length;
                                                        i++) ...[
                                                      Text(
                                                        (i != 0 ? ' • ' : '') +
                                                            infoList[i],
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                              FilmRatingRow(
                                                rating: widget.film.rating,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: Style.padding,
                          ),
                          child: FilmDescription(
                            film: widget.film,
                          ),
                        ),
                        if (widget.film.showings.isNotEmpty) ...[
                          for (Showing showing in widget.film.showings) ...[
                            Text(showing.date.toString()),
                          ],
                        ],
                        for (int i = 0; i < 2; i++) ...[
                          Container(
                            padding: const EdgeInsets.only(
                              top: Style.padding,
                            ),
                            child: const Placeholder(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (videoPlayer != null) ...[
              Visibility(
                maintainState: true,
                visible: false,
                 child: videoPlayer!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
