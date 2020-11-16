import 'package:flutter/material.dart';
import 'package:AchaFacil/login/login.dart';

import '../constants.dart';

class CustomDrawerAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(mainTitleApp),
            accountEmail: Text('admin@achafacil.com')),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sair'),
          subtitle: Text('Logout'),
          onTap: () {
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
