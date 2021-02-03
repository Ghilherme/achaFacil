import 'package:flutter/material.dart';

import '../constants.dart';

class TimeTableAdmin extends StatelessWidget {
  final Map<String, dynamic> timeTable;
  final Function(Map<String, dynamic>) callback;
  final String preFillTimeTable;

  const TimeTableAdmin(
      {Key key, this.timeTable, this.callback, this.preFillTimeTable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      for (int x = 0; x < weekDays.length; x++) buildItem(x)
    ]);
  }

  TextFormField buildItem(int x) {
    String initialValue = '';

    //Comercial
    if (preFillTimeTable == schedule[1]) {
      initialValue = x == 6 || x == 5 ? "Fechado" : "08:00-18:00";
      timeTable[weekDays[x].dayName] = initialValue;
    }

    //Com Agendamento
    if (preFillTimeTable == schedule[2]) {
      initialValue = 'Agendar';
      timeTable[weekDays[x].dayName] = initialValue;
    }

    return TextFormField(
        initialValue: timeTable[weekDays[x].dayName] == null ||
                timeTable[weekDays[x].dayName] == ''
            ? initialValue
            : timeTable[weekDays[x].dayName],
        onChanged: (value) {
          timeTable[weekDays[x].dayName] = value;
          callback(timeTable);
        },
        keyboardType: TextInputType.text,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: weekDays[x].dayName,
          hintText: x == 6 || x == 5 ? "Fechado" : "08:00-18:00",
        ));
  }
}
