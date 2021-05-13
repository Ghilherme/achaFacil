import 'package:AchaFacil/screens/home/home_screen.dart';
import 'package:AchaFacil/screens/profile/profile.dart';
import 'package:AchaFacil/screens/search/search.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => HomeScreen(),
  Profile.routeName: (context) => Profile(),
  Search.routeName: (context) => Search(),
};
