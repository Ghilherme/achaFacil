import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens_lists/body_service_list.dart';

class BodyCategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Pega a tabela categorias
    Query query =
        FirebaseFirestore.instance.collection('categorias').orderBy('titulo');

    //Cria Stream com essa query
    return StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          QuerySnapshot querySnapshot = stream.data;

          return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: querySnapshot.size,
              itemBuilder: (context, index) {
                return _buildRow(context, querySnapshot.docs[index], index,
                    querySnapshot.size);
              });
        });
  }

  Widget _buildRow(
      BuildContext context, DocumentSnapshot snapshot, int indice, int size) {
    return Column(children: <Widget>[
      ListTile(
          title: Text(
            snapshot.data()['titulo'],
          ),
          subtitle: Text(snapshot.data()['subtitulo']),
          leading:
              snapshot.data()['icone'] == null || snapshot.data()['icone'] == ''
                  ? Icon(Icons.home_repair_service)
                  : Icon(IconData(
                      int.parse(snapshot.data()['icone']),
                      fontFamily: 'MaterialIcons',
                    )),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyServiceList(
                      category: snapshot.reference,
                      title: snapshot.data()['titulo'],
                    )));
          }),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
