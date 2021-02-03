import 'package:AchaFacil/screens_admin/body_admin_area.dart';
import 'package:AchaFacil/screens_lists/body_contact_list.dart';
import 'package:AchaFacil/screens_register/register_journey.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            accountName: Text(mainTitleApp),
            accountEmail: Text('Tudo em 3 cliques ou menos!')),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favoritos'),
          subtitle: Text('Meus contatos preferidos'),
          onTap: () async {
            final SharedPreferences prefs = await _prefs;
            var cacheFavorites = prefs.getStringList('favoritos');
            if (cacheFavorites == null || cacheFavorites.isEmpty)
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
                  builder: (context) => BodyContactList(
                        title: 'Favoritos!',
                        idFavorites: cacheFavorites
                            .map((e) => DateTime.parse(e))
                            .toList(),
                      )));
          },
        ),
        ListTile(
          leading: Icon(Icons.login),
          title: Text('Área'),
          subtitle: Text('Administrativa'),
          onTap: () async {
            final SharedPreferences prefs = await _prefs;
            if (prefs.getBool('logado') != null && prefs.getBool('logado'))
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BodyAdminArea()));
            else
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Login()));
          },
        ),
        ListTile(
          leading: Icon(Icons.save),
          title: Text('Solicitar'),
          subtitle: Text('Criação de prestadores'),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RegisterJourney()));
          },
        ),
      ],
    ));
  }
}
