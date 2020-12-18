import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/apis/models/rating.dart';
import 'package:AchaFacil/components/current_location.dart';
import 'package:AchaFacil/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/screens_details/body_contact_details.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';

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
                padding: EdgeInsets.all(kDefaultPaddingListView),
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
          isThreeLine: true,
          leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  contact.imageAvatar == '' || contact.imageAvatar == null
                      ? AssetImage('assets/images/contacts.jpeg')
                      : Image.network(contact.imageAvatar).image),
          subtitle: Text("Atendimento: " +
              contact.rating.attendance.toStringAsFixed(1) +
              '\n' +
              'Qualidade: ' +
              contact.rating.quality.toStringAsFixed(1) +
              '\n' +
              'Preço: ' +
              contact.rating.price.toStringAsFixed(1)),
          title: Text(
            contact.name,
          ),
          trailing: RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: contact.rating.general.toStringAsFixed(1) + "\n",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: contact.address.coordinates == null
                      ? ''
                      : (Geolocator.distanceBetween(
                                          CurrentPositionInherited.of(context)
                                              .currentPosition
                                              .latitude,
                                          CurrentPositionInherited.of(context)
                                              .currentPosition
                                              .longitude,
                                          contact.address.coordinates.latitude,
                                          contact.address.coordinates.longitude)
                                      .floor() /
                                  1000)
                              .toStringAsFixed(1) +
                          ' kms',
                  style: TextStyle(fontSize: 11, color: kTextLightColor),
                ),
              ],
            ),
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
