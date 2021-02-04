import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/apis/models/contacts_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/screens_details/body_contact_details.dart';
import 'package:geolocator/geolocator.dart';

import '../constants.dart';

class BodyContactList extends StatelessWidget {
  BodyContactList(
      {Key key, @required this.title, this.serviceType, this.idFavorites})
      : super(key: key);
  final String title;
  final DocumentReference serviceType;
  final List<DateTime> idFavorites;

  @override
  Widget build(BuildContext context) {
    //Pega a tabela contatos somente dos prestadores cadastrados com x categoria
    Query query = idFavorites == null
        ? FirebaseFirestore.instance
            .collection('contatos')
            .where('servicos', arrayContains: title)
            .orderBy('avaliacao.geral', descending: true)
        : FirebaseFirestore.instance
            .collection('contatos')
            .where('criacao', whereIn: idFavorites)
            .orderBy('avaliacao.geral', descending: true);

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
            var contatos = _orderContactsByDistance(querySnapshot.docs);

            return ListView.builder(
                padding: EdgeInsets.all(kDefaultPaddingListView),
                itemCount: contatos.length,
                itemBuilder: (context, i) {
                  return _buildRow(context, contatos, i, contatos.length);
                });
          },
        ));
  }

  String _distanceBetweenKms(double startLat, startLon, endLat, endLon) {
    return (Geolocator.distanceBetween(startLat, startLon, endLat, endLon)
                .floor() /
            1000)
        .toStringAsFixed(1);
  }

  Widget _buildRow(BuildContext context, List<DistanceContact> contacts,
      int indice, int size) {
    ContactsModel contact = contacts.elementAt(indice).contact;
    if (contact.status == Status.pending) //se for pendente não exibe
      return Container();
    String kms = contacts.elementAt(indice).distance.toString();
    return Column(children: <Widget>[
      ListTile(
          //isThreeLine: true,
          leading: CircleAvatar(
              radius: 25,
              backgroundImage:
                  contact.imageAvatar == '' || contact.imageAvatar == null
                      ? Image.network(urlAvatarInitials + contact.name).image
                      : Image.network(contact.imageAvatar).image),
          subtitle: contact.rating.general == 0
              ? Text('Seja o primeiro a avaliar!')
              : Text(
                  "Atendimento: " +
                      contact.rating.attendance.toStringAsFixed(1) +
                      '\n' +
                      'Qualidade: ' +
                      contact.rating.quality.toStringAsFixed(1) +
                      '\n' +
                      'Preço: ' +
                      contact.rating.price.toStringAsFixed(1),
                  style: TextStyle(fontSize: 13.0, color: Colors.grey),
                ),
          title: Text(
            contact.name,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: contact.rating.general == 0
                      ? '--'
                      : contact.rating.general.toStringAsFixed(1),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' '),
                WidgetSpan(
                  child: Icon(
                    Icons.star,
                    color: contact.rating.general == 0
                        ? Colors.grey
                        : Colors.amber,
                    size: 20,
                  ),
                ),
                TextSpan(text: '\n'),
                TextSpan(
                  text: kms.isEmpty ? '' : kms + ' kms',
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

  List<DistanceContact> _orderContactsByDistance(
      List<QueryDocumentSnapshot> querySnapshots) {
    Position _currentPosition = globalPosition;

    List<DistanceContact> distanceContacts = List<DistanceContact>();
    for (var querySnapshot in querySnapshots) {
      ContactsModel contact = ContactsModel.fromFirestore(querySnapshot);
      var distance =
          contact.address.coordinates == null || _currentPosition == null
              ? 0.0
              : double.parse(_distanceBetweenKms(
                  _currentPosition.latitude,
                  _currentPosition.longitude,
                  contact.address.coordinates.latitude,
                  contact.address.coordinates.longitude));

      distanceContacts
          .add(DistanceContact(distance: distance, contact: contact));
    }
    distanceContacts.sort((a, b) => a.distance.compareTo(b.distance));

    return distanceContacts;
  }
}

class DistanceContact {
  DistanceContact({this.distance, this.contact});
  double distance;
  ContactsModel contact;
}
