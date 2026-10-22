import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/date_util.dart';

class WeekButtonList extends StatefulWidget {
  final EdgeInsets margin;
  final Function(DateTime dateSelected) onChanged;

  const WeekButtonList({Key? key, this.margin = EdgeInsets.zero, required this.onChanged})
      : super(key: key);

  @override
  _WeekButtonListState createState() => _WeekButtonListState();
}

class _WeekButtonListState extends State<WeekButtonList> {
  late DateTime today;
  late DateTime dateSelected;

  @override
  void initState() {
    today = DateTime.now();
    dateSelected = today;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    today = DateTime.now();

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 7,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.only(
            left: i == 0 ? widget.margin.left : widget.margin.left / 4,
            right: i == 6 ? widget.margin.right : widget.margin.right / 4,
          ),
          child: TextButton(
            onPressed: () {
              if (!dateSelected.isSameDay(today.addDays(i))) {
                setState(() => dateSelected = today.addDays(i));
                widget.onChanged(dateSelected);
              }
            },
            style: TextButton.styleFrom(
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
}
