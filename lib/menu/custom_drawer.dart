import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            currentAccountPicture: Center(
              child: ClipOval(
                child: Image.asset('assets/images/profile.jpg'),
              ),
            ),
            accountName: Text('Guilherme Oliveira'),
            accountEmail: Text('g.p.oliveira@hotmail.com')),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Perfil'),
          subtitle: Text('Meu perfil'),
          onTap: () {
            print('tapeou perfil');
          },
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favoritos'),
          subtitle: Text('Meus contatos preferidos'),
          onTap: () {
            print('tapeou ordens');
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sair'),
          subtitle: Text('Logout'),
          onTap: () {
            print('tapeou Logout');
          },
        ),
      ],
    ));
  }
}
