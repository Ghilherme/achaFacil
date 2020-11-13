import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/screens_details/body_contact_details.dart';

class BodyContactList extends StatelessWidget {
  BodyContactList({Key key, @required this.title, this.serviceType})
      : super(key: key);
  final String title;
  final DocumentReference serviceType;

  @override
  Widget build(BuildContext context) {
    //Pega a tabela contatos somente dos prestadores cadastrados com x categoria
    Query query = FirebaseFirestore.instance
        .collection('contatos')
        .where('servicos1', arrayContains: serviceType);

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
                  return _buildRow(context, querySnapshot.docs[i].data(), i,
                      querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(BuildContext context, Map<String, dynamic> snapshot,
      int indice, int size) {
    return Column(children: <Widget>[
      ListTile(
          trailing: Icon(Icons.warning),
          leading: Icon(Icons.warning),
          subtitle: Text('Avaliação: 5'),
          title: Text(
            snapshot['nome'],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactDetails(
                      contact: snapshot,
                    )));
          }),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
