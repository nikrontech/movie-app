import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/date_util.dart';

class WeekButtonList extends StatefulWidget {
  final EdgeInsets margin;
  final DateTime? initialDate;
  final bool initialNow;
  final Function(DateTime dateSelected) onChanged;
  final VoidCallback? onNowPressed;

  const WeekButtonList({
    Key? key,
    this.margin = EdgeInsets.zero,
    this.initialDate,
    this.initialNow = false,
    required this.onChanged,
    this.onNowPressed,
  }) : super(key: key);

  @override
  _WeekButtonListState createState() => _WeekButtonListState();
}

class _WeekButtonListState extends State<WeekButtonList> {
  late DateTime today;
  late DateTime dateSelected;
  late bool nowSelected;
  late final ScrollController scrollController;
  late final List<GlobalKey> dayKeys;

  @override
  void initState() {
    today = DateTime.now();
    dateSelected = widget.initialDate ?? today;
    nowSelected = widget.initialNow;
    scrollController = ScrollController();
    dayKeys = List<GlobalKey>.generate(8, (_) => GlobalKey());
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
  void didUpdateWidget(covariant WeekButtonList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != null &&
        !widget.initialDate!.isSameDay(dateSelected)) {
      dateSelected = widget.initialDate!;
      nowSelected = widget.initialNow;
      _scrollToSelectedDay(animate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    today = DateTime.now();

    return ListView.builder(
      controller: scrollController,
      cacheExtent: 1000,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 8,
      itemBuilder: (context, i) {
        return Container(
          key: dayKeys[i],
          margin: EdgeInsets.only(
            left: i == 0 ? widget.margin.left : widget.margin.left / 4,
            right: i == 6 ? widget.margin.right : widget.margin.right / 4,
          ),
          child: TextButton(
            onPressed: () => _selectDay(i),
            style: TextButton.styleFrom(
              minimumSize: const Size(72, 48),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              backgroundColor: _isSelected(i)
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor,
            ),
            child: Text(_labelFor(i),
                style: TextStyle(
                    color: _isSelected(i)
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.secondary)),
          ),
        );
      },
    );
  }

  void _selectDay(int index) {
    if (index == 0) {
      setState(() => nowSelected = true);
      widget.onNowPressed?.call();
      if (widget.onNowPressed == null) widget.onChanged(DateTime.now());
      return;
    }

    final date = today.addDays(index - 1);
    if (dateSelected.isSameDay(date) && !nowSelected) return;
    setState(() {
      nowSelected = false;
      dateSelected = date;
    });
    _scrollToSelectedDay();
    widget.onChanged(date);
  }

  bool _isSelected(int index) => index == 0
      ? nowSelected
      : !nowSelected && dateSelected.isSameDay(today.addDays(index - 1));

  String _labelFor(int index) =>
      index == 0 ? 'Dabar' : DateUtil.getWeekDay(today.addDays(index - 1));

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
    for (int i = 1; i < 8; i++) {
      if (!nowSelected && dateSelected.isSameDay(today.addDays(i - 1))) {
        return i;
      }
    }
    return null;
  }
}
