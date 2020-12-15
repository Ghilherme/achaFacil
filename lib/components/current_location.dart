import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class CurrentLocation extends StatelessWidget {
  final Placemark currentPosition;

  const CurrentLocation({
    Key key,
    this.currentPosition,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: currentPosition.subLocality + ",\n",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: currentPosition.subAdministrativeArea,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
