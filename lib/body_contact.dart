import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/categories.dart';
import 'package:listaUnica/apis/models/contacts.dart';

class BodyContactList extends StatelessWidget {
  BodyContactList({Key key, @required this.contacts, @required this.title})
      : super(key: key);
  final List<Contacts> contacts;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, i) {
            return _buildRow(context, contacts[i], i);
          }),
    );
  }

  Widget _buildRow(BuildContext context, Contacts con, int indice) {
    return Column(children: <Widget>[
      ListTile(
          title: Text(
            con.name,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                    title: Text('Contato'),
                    content: Row(
                      children: [
                        Icon(Icons.phonelink_ring),
                        Text(con.number),
                      ],
                    )));
          }),
      indice + 1 == categories.length ? Container() : Divider()
    ]);
  }
}
