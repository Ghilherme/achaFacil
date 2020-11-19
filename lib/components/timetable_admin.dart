import 'package:flutter/material.dart';

import '../constants.dart';

class TimeTableAdmin extends StatelessWidget {
  final Map<String, dynamic> timeTable;
  final Function(Map<String, dynamic>) callback;

  const TimeTableAdmin({Key key, this.timeTable, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      for (int x = 0; x < weekDays.length; x++) buildItem(x)
    ]);
  }

  ListTile buildItem(int x) {
    return ListTile(
      leading: Text(weekDays[x].dayName),
      title: TextFormField(
        initialValue: timeTable[weekDays[x].dayName],
        onChanged: (value) {
          timeTable[weekDays[x].dayName] = value;
          callback(timeTable);
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: x == 6 || x == 5 ? "Fechado" : "08:00-18:00",
        ),
      ),
    );
  }
}
