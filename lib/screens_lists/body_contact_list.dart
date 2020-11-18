import 'package:AchaFacil/apis/models/contacts.dart';
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
        .where('servicos', arrayContains: title);

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

  Widget _buildRow(BuildContext context, QueryDocumentSnapshot snapshot,
      int indice, int size) {
    ContactsModel contact = ContactsModel.fromFirestore(snapshot);
    return Column(children: <Widget>[
      ListTile(
          leading: CircleAvatar(
              radius: 25,
              backgroundImage: contact.imageAvatar == ''
                  ? AssetImage('assets/images/contacts.jpeg')
                  : Image.network(contact.imageAvatar).image),
          subtitle: Text('Avaliação: 5'),
          title: Text(
            contact.name,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactDetails(
                      contact: contact,
                    )));
          }),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
