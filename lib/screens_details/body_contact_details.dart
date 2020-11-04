import 'package:flutter/material.dart';

import '../constants.dart';
import 'title_address_name.dart';
import 'backdrop_rating.dart';
import 'genres.dart';

class BodyContactDetails extends StatelessWidget {
  BodyContactDetails({Key key, @required this.contact}) : super(key: key);
  final Map<String, dynamic> contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(contact: contact),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Zap'),
        icon: Icon(Icons.call),
      ),
    );
  }
}

class Body extends StatelessWidget {
  final Map<String, dynamic> contact;

  const Body({Key key, this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackdropAndRating(
            size: size,
            movie: 'movie',
            image: contact['imagem'],
          ),
          SizedBox(height: kDefaultPadding / 2),
          TitleAdressName(
            name: contact['nome'],
            city: contact['endereco']['cidade'],
            neighbourhood: contact['endereco']['bairro'],
            uf: contact['endereco']['UF'],
          ),
          ServiceTypes(servicos: contact['servicos']),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Sobre",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              contact['descricao'],
              style: TextStyle(
                color: kTextLightColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
