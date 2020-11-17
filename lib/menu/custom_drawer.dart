import 'package:flutter/material.dart';
import 'package:AchaFacil/login/login.dart';

import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(mainTitleApp),
            accountEmail: Text('admin@achafacil.com')),
        ListTile(
          leading: Icon(Icons.home),
          enabled: false,
          title: Text('Perfil'),
          subtitle: Text('Meu perfil'),
          onTap: () {
            print('tapeou perfil');
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favoritos'),
          enabled: false,
          subtitle: Text('Meus contatos preferidos'),
          onTap: () {
            print('tapeou ordens');
          },
        ),
        ListTile(
          leading: Icon(Icons.save),
          title: Text('Cadastrar'),
          subtitle: Text('Prestadores'),
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Login()));
          },
        ),
      ],
    ));
  }
}
