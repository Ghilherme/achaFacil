import 'package:AchaFacil/apis/models/weekdays.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../constants.dart';

class TimeTable extends StatelessWidget {
  final Map<String, dynamic> timeTable;

  const TimeTable({Key key, @required this.timeTable}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    buildItem(String key, String value) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Text(key,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: kTextLightColor,
                  )),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Text(value,
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: kTextLightColor,
                  )),
        ),
      ]);
    }

    buildList() {
      Map<String, String> result = {
        for (var value in weekDays) value.dayName: timeTable[value.dayName]
      };

      return Column(children: <Widget>[
        for (var t in result.entries) buildItem(t.key, t.value ?? ''),
      ]);
    }

    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: ScrollOnExpand(
        child: Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.schedule,
                            collapseIcon: Icons.schedule,
                            iconColor: Colors.blue,
                            iconSize: 28.0,
                            iconRotationAngle: 0,
                            iconPadding: EdgeInsets.only(right: 20),
                            hasIcon: false,
                          ),
                        ),
                        Expanded(
                          child: Text("Horários",
                              style: TextStyle(
                                  color: kTextColor.withOpacity(0.8),
                                  fontSize: 16)),
                        ),
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: Icons.arrow_right,
                            collapseIcon: Icons.arrow_drop_down,
                            iconColor: Colors.black,
                            iconSize: 28.0,
                            iconRotationAngle: math.pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                expanded: buildList(),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
