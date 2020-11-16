import 'package:flutter/material.dart';

import '../constants.dart';
import 'body_categories_list.dart';
import '../menu/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  // This widget is the root of your application.
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
        ),
        body: BodyCategoriesList(),
      ),
    );
  }
}
