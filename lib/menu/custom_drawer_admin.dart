import 'package:AchaFacil/screens/home/home_screen.dart';
import 'package:AchaFacil/screens/login/login.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class CustomDrawerAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            accountName: Text(mainTitleApp),
            accountEmail: Text(emailApp)),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          subtitle: Text('Página Principal'),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sair'),
          subtitle: Text('Logout'),
          onTap: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setBool('logado', false);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ));
          },
        ),
      ],
    ));
  }
}
