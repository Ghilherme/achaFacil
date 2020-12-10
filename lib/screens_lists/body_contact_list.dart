import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/apis/models/rating.dart';
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

  Widget _buildSubtitle(RatingModel rating) {
    return Column(
      children: [
        Row(
          children: [
            Text("Atendimento: " + rating.attendance.toStringAsFixed(1))
          ],
        ),
        Row(
          children: [Text("Qualidade: " + rating.quality.toStringAsFixed(1))],
        ),
        Row(
          children: [Text("Preço: " + rating.price.toStringAsFixed(1))],
        )
      ],
    );
  }

  Widget _buildRow(BuildContext context, QueryDocumentSnapshot snapshot,
      int indice, int size) {
    ContactsModel contact = ContactsModel.fromFirestore(snapshot);
    return Column(children: <Widget>[
      ListTile(
          leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  contact.imageAvatar == '' || contact.imageAvatar == null
                      ? AssetImage('assets/images/contacts.jpeg')
                      : Image.network(contact.imageAvatar).image),
          subtitle: _buildSubtitle(contact.rating),
          title: Text(
            contact.name,
          ),
          trailing: Text(
            contact.rating.general.toStringAsFixed(1),
            style: TextStyle(fontSize: 15),
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
