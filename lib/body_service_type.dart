import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listaUnica/body_contact.dart';

import 'apis/models/contacts.dart';

class BodyServiceList extends StatelessWidget {
  BodyServiceList({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    //Pega a tabela categorias somente da categoria selecionada
    Query query = FirebaseFirestore.instance
        .collection('prestadores')
        .where(
          'titulo_categoria',
          isEqualTo: title,
        )
        .orderBy('nome');

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
        body: StreamBuilder(
          stream: query.snapshots(),
          builder: (context, stream) {
            //Trata Load
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            //Trata Erro
            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: querySnapshot.size,
                itemBuilder: (context, i) {
                  return _buildRow(
                      context, querySnapshot.docs[i], i, querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(
      BuildContext context, DocumentSnapshot snapshot, int indice, int size) {
    return Column(children: <Widget>[
      ListTile(
          title: Text(
            snapshot.data()['nome'],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactList(
                      title: snapshot.data()['nome'],
                    )));
          }),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
