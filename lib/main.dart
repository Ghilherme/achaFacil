import 'package:AchaFacil/routes.dart';
import 'package:AchaFacil/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: mainTitleApp,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            actionsIconTheme: IconThemeData(color: Colors.blue),
            color: Colors.white,
            elevation: 0,
            centerTitle: true,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            textTheme: TextTheme(
              headline6: TextStyle(color: kPrimaryColor, fontSize: 18),
            ),
          )),

      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}
