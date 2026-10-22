import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/date_util.dart';

class WeekButtonList extends StatefulWidget {
  final EdgeInsets margin;
  final DateTime? initialDate;
  final Function(DateTime dateSelected) onChanged;

  const WeekButtonList({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.initialDate,
    required this.onChanged,
  }) : super(key: key);

  @override
  _WeekButtonListState createState() => _WeekButtonListState();
}

class _WeekButtonListState extends State<WeekButtonList> {
  late DateTime today;
  late DateTime dateSelected;
  late final ScrollController scrollController;
  late final List<GlobalKey> dayKeys;

  @override
  void initState() {
    today = DateTime.now();
    dateSelected = widget.initialDate ?? today;
    scrollController = ScrollController();
    dayKeys = List<GlobalKey>.generate(7, (_) => GlobalKey());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay(animate: false);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    today = DateTime.now();

    return ListView.builder(
      controller: scrollController,
      cacheExtent: 1000,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, i) {
        return Container(
          key: dayKeys[i],
          margin: EdgeInsets.only(
            left: i == 0 ? widget.margin.left : widget.margin.left / 4,
            right: i == 6 ? widget.margin.right : widget.margin.right / 4,
          ),
          child: TextButton(
            onPressed: () {
              if (!dateSelected.isSameDay(today.addDays(i))) {
                setState(() => dateSelected = today.addDays(i));
                _scrollToSelectedDay();
                widget.onChanged(dateSelected);
              }
            },
            style: TextButton.styleFrom(
              minimumSize: const Size(72, 48),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              backgroundColor: dateSelected.isSameDay(today.addDays(i))
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor,
            ),
            child: Text(DateUtil.getWeekDay(today.addDays(i)),
                style: TextStyle(
                    color: dateSelected.isSameDay(today.addDays(i))
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary)),
          ),
        );
      },
    );
  }

  void _scrollToSelectedDay({bool animate = true}) {
    final index = _selectedDayIndex();
    if (index == null || dayKeys[index].currentContext == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || dayKeys[index].currentContext == null) return;
      Scrollable.ensureVisible(
        dayKeys[index].currentContext!,
        alignment: 0.5,
        duration: animate ? const Duration(milliseconds: 200) : Duration.zero,
        curve: Curves.easeOut,
      );
    });
  }

  int? _selectedDayIndex() {
    for (int i = 0; i < 7; i++) {
      if (dateSelected.isSameDay(today.addDays(i))) return i;
    }
    return null;
  }
}
