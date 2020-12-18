import 'package:AchaFacil/components/current_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../constants.dart';
import 'body_categories_list.dart';
import '../menu/custom_drawer.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Placemark _currentPlaceMark;
  Position _currentPosition;

  initState() {
    super.initState();
    //Get the current location of user
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return CurrentPositionInherited(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: mainTitleApp,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Scaffold(
              drawer: CustomDrawer(),
              appBar: AppBar(
                title: Text(mainTitleApp),
                actions: [
                  _currentPlaceMark == null
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            backgroundColor: Colors.white,
                          ),
                        )
                      : CurrentLocation(currentPlaceMark: _currentPlaceMark),
                ],
              ),
              body: BodyCategoriesList(),
            )),
        currentPosition: _currentPosition);
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    var pos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = pos;
    });

    print(pos.latitude);
    print(pos.longitude);

    placemarkFromCoordinates(pos.latitude, pos.longitude)
        .then((value) => setState(() {
              _currentPlaceMark = value.first;
            }))
        .whenComplete(() {
      print(_currentPlaceMark.street);
      print(_currentPlaceMark.locality);
      print(_currentPlaceMark.administrativeArea);
      print(_currentPlaceMark.country);
      print(_currentPlaceMark.name);
      print(_currentPlaceMark.subAdministrativeArea);
      print(_currentPlaceMark.subLocality);
      print(_currentPlaceMark.subThoroughfare);
      print(_currentPlaceMark.thoroughfare);
    });

    /* locationFromAddress('Dracena').then((value) => print(
        value.first.latitude.toString() +
            "  -  " +
            value.first.longitude.toString())); */
  }
}

class CurrentPositionInherited extends InheritedWidget {
  const CurrentPositionInherited({
    Key key,
    @required this.currentPosition,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  final Position currentPosition;

  static CurrentPositionInherited of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(CurrentPositionInherited old) =>
      currentPosition != old.currentPosition;
}
