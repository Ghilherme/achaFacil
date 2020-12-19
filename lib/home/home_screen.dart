import 'package:AchaFacil/components/current_location.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'body_categories_list.dart';
import '../menu/custom_drawer.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              CurrentLocation(),
            ],
          ),
          body: BodyCategoriesList(),
        ));
  }
}
