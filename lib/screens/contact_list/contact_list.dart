import 'package:AchaFacil/components/custom_bottom_nav_bar.dart';
import 'package:AchaFacil/screens/contact_list/components/body_contact_list.dart';
import 'package:AchaFacil/screens/contact_list/components/contact_list_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../../constants.dart';

class ContactList extends StatelessWidget {
  const ContactList(
      {Key key, this.title, this.menuState, this.serviceType, this.idFavorites})
      : super(key: key);
  final String title;
  final MenuState menuState;
  final DocumentReference serviceType;
  final List<DateTime> idFavorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactListHeader(),
            BodyContactList(
              title: title,
              serviceType: serviceType,
              idFavorites: idFavorites,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
