import 'package:AchaFacil/components/not_found.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/models/contacts.dart';
import 'package:AchaFacil/models/contacts_status.dart';
import 'package:AchaFacil/screens/details/contact_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';

class BodyContactList extends StatelessWidget {
  BodyContactList({
    Key key,
    @required this.title,
    this.serviceType,
    this.idFavorites,
  }) : super(key: key);
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

    return StreamBuilder(
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

        if (contatos.length == 0) {
          return NotFound();
        }

        return Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(kDefaultPaddingListView),
              itemCount: contatos.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, i) {
                return _buildRow(context, contatos, i, contatos.length);
              }),
        );
      },
    );
  }

  String _distanceBetweenKms(double startLat, startLon, endLat, endLon) {
    return (Geolocator.distanceBetween(startLat, startLon, endLat, endLon)
                .floor() /
            1000)
        .toStringAsFixed(1);
  }

  Widget _buildRow(
      BuildContext context, List<DistanceContact> contacts, int i, int size) {
    ContactsModel contact = contacts.elementAt(i).contact;
    if (contact.status !=
        Status.active) //se for qualquer status diferente de ativo não exibe
      return Container();
    String kms = contacts.elementAt(i).distance.toString();
    return Column(children: <Widget>[
      InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ContactDetails(
                    contact: contact,
                  )));
        },
        child: Container(
          height: 100.0,
          margin: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          child: Stack(children: [
            Container(
              height: 100.0,
              margin: EdgeInsets.only(left: 46.0),
              decoration: BoxDecoration(
                color: Color(0xFFf2f2f2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Container(
                margin: new EdgeInsets.fromLTRB(30.0, 16.0, 16.0, 16.0),
                constraints: new BoxConstraints.expand(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: kTextColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(contact.rating.general.toString() + ' ',
                                  style: TextStyle(color: kTextColor)),
                              RatingBarIndicator(
                                rating: contact.rating.general,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            contact.address.neighborhood +
                                ' - ' +
                                contact.address.city,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 13, color: kTextLightColor),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          kms.isEmpty ? '' : kms + ' kms',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6.0),
              alignment: FractionalOffset.centerLeft,
              child: CircleAvatar(
                  radius: 30,
                  backgroundImage: contact.imageAvatar == '' ||
                          contact.imageAvatar == null
                      ? Image.network(urlAvatarInitials + contact.name).image
                      : Image.network(contact.imageAvatar).image),
              height: 92,
              width: 92.0,
            ),
          ]),
        ),
      )

      //i + 1 == size ? Container() : Divider()
    ]);
  }

  List<DistanceContact> _orderContactsByDistance(
      List<QueryDocumentSnapshot> querySnapshots) {
    Position _currentPosition = globalPosition;

    List<DistanceContact> distanceContacts = [];
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
