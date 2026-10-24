import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:movie_app/app_text.dart';

class SliverSearchBar extends StatefulWidget {
  final Function(String searchText) onSubmitted;
  final Function(String searchText)? onChanged;
  final VoidCallback? onBackPressed;
  final bool autofocus;
  final String placeholder;
  final bool alwaysOpen;

  const SliverSearchBar({
    Key? key,
    required this.onSubmitted,
    this.onChanged,
    this.onBackPressed,
    this.autofocus = true,
    this.placeholder = "",
    this.alwaysOpen = false,
  }) : super(key: key);

  @override
  _SliverSearchBarState createState() => _SliverSearchBarState();
}

class _SliverSearchBarState extends State<SliverSearchBar> {
  late TextEditingController searchController;
  late bool showTextField;
  late bool showSearchIcon;
  late bool showClearIcon;
  late bool showBackButton;

  @override
  void initState() {
    showTextField = widget.alwaysOpen;
    showSearchIcon = !widget.alwaysOpen;
    showClearIcon = false;
    showBackButton = false;
    searchController = TextEditingController(text: widget.placeholder);

    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible && showBackButton) toggle();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void toggle() {
    setState(() {
      showClearIcon = !showClearIcon;
      showBackButton = !showBackButton;

      if (widget.alwaysOpen) {
        FocusScope.of(context).unfocus();
      } else {
        searchController.clear();
        showTextField = !showTextField;
        showSearchIcon = !showTextField;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Theme.of(context).platform == TargetPlatform.iOS
                    ? Icons.arrow_back_ios
                    : Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: widget.onBackPressed ?? toggle,
            )
          : showTextField
              ? null
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/icon_transparent.png',
                    fit: BoxFit.contain,
                  ),
                ),
      title: showTextField
          ? TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: AppText.searchMovies,
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
              textInputAction: TextInputAction.search,
              autofocus: widget.autofocus,
              autocorrect: false,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
              onSubmitted: (String searchText) {
                if (searchText.trim().isNotEmpty) {
                  widget.onSubmitted(searchText);
                }
              },
              onChanged: widget.onChanged,
              onTap: () {
                if (widget.alwaysOpen) {
                  setState(() {
                    showClearIcon = true;
                    showBackButton = true;
                  });
                }
              },
            )
          : null,
      floating: true,
      elevation: Theme.of(context).appBarTheme.elevation,
      actions: <Widget>[
        if (showSearchIcon) ...[
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.search),
            onPressed: () {
              toggle();
            },
          ),
        ] else if (showClearIcon) ...[
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: const Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
            },
          ),
        ],
      ],
    );
  }
}
