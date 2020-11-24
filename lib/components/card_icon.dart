import 'package:flutter/material.dart';

import '../constants.dart';

class CardIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const CardIcon({Key key, this.title, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: kDefaultPaddin),
                  child: Icon(icon, color: Colors.blue, size: 28),
                ),
                Flexible(
                  child: Text(title,
                      style: TextStyle(
                          color: kTextColor.withOpacity(0.8), fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
