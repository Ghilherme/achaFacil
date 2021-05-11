import 'package:AchaFacil/screens/home/components/body_contact_list.dart';
import 'package:AchaFacil/screens/home/home_screen.dart';
import 'package:AchaFacil/screens/profile/profile.dart';
import 'package:AchaFacil/screens/search/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: MenuState.search == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => Navigator.pushNamed(context, Search.routeName),
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                color: MenuState.favorites == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
                onPressed: () async {
                  final SharedPreferences prefs = await _prefs;
                  var cacheFavorites = prefs.getStringList('favoritos');
                  if (cacheFavorites == null || cacheFavorites.isEmpty)
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Ops...'),
                          content:
                              Text('Adicione um contato aos favoritos antes!'),
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
              IconButton(
                icon: Icon(Icons.person),
                color: MenuState.profile == selectedMenu
                    ? kPrimaryColor
                    : inActiveIconColor,
                onPressed: () =>
                    Navigator.pushNamed(context, Profile.routeName),
              ),
            ],
          )),
    );
  }
}
