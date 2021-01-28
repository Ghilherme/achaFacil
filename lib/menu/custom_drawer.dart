import 'package:AchaFacil/screens_lists/favorites_list.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(mainTitleApp),
            accountEmail: Text('Tudo em 3 cliques ou menos!')),
        ListTile(
          leading: Icon(Icons.home),
          enabled: false,
          title: Text('Perfil'),
          subtitle: Text('Meu perfil'),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favoritos'),
          subtitle: Text('Meus contatos preferidos'),
          onTap: () async {
            final SharedPreferences prefs = await _prefs;
            if (prefs.getStringList('favoritos').isEmpty)
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Ops...'),
                    content: Text('Adicione um contato aos favoritos antes!'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            else
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FavoritesList(
                        idDates: prefs.getStringList('favoritos'),
                      )));
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
