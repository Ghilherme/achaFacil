import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class CardIcon extends StatelessWidget {
  final String title, imagePath;
  final IconData icon;
  final Function onTap;

  const CardIcon({Key key, this.title, this.icon, this.imagePath, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey();
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: onTap ??
                () {
                  Clipboard.setData(ClipboardData(text: title));
                },
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: title));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Tooltip(
                key: key,
                message: 'Copiado!',
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: kDefaultPadding),
                      child: icon == null
                          ? Image.asset(
                              imagePath,
                              height: 28,
                              width: 28,
                            )
                          : Icon(icon, color: Colors.blue, size: 28),
                    ),
                    Flexible(
                      child: Text(title,
                          style: TextStyle(
                              color: kTextColor.withOpacity(0.8),
                              fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
