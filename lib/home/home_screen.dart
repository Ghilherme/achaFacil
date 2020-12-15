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
  Placemark currentPlace;

  initState() {
    super.initState();
    //Get the current location of user
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            currentPlace == null
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                    ),
                  )
                : CurrentLocation(currentPosition: currentPlace),
          ],
        ),
        body: BodyCategoriesList(),
      ),
    );
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

    print(pos.latitude);
    print(pos.longitude);

    placemarkFromCoordinates(pos.latitude, pos.longitude)
        .then((value) => setState(() {
              currentPlace = value.first;
            }))
        .whenComplete(() {
      print(currentPlace.street);
      print(currentPlace.locality);
      print(currentPlace.administrativeArea);
      print(currentPlace.country);
      print(currentPlace.name);
      print(currentPlace.subAdministrativeArea);
      print(currentPlace.subLocality);
      print(currentPlace.subThoroughfare);
      print(currentPlace.thoroughfare);
    });
  }
}
