import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({
    Key key,
  }) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  Address _currentPlaceMark;
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _currentPlaceMark == null
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: _currentPlaceMark.subLocality + ",\n",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: _currentPlaceMark.subAdminArea,
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
