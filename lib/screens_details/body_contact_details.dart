import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/expandable_widget.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'title_address_name.dart';
import 'backdrop_rating.dart';
import 'genres.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expandable/expandable.dart';

class BodyContactDetails extends StatelessWidget {
  BodyContactDetails({Key key, @required this.contact}) : super(key: key);
  final ContactsModel contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(contact: contact),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          launchZap(contact.telNumbers['whatsapp']);
        },
        label: Text('Zap'),
        icon: Icon(Icons.call),
      ),
    );
  }

  Future<bool> launchZap(numberPhone) async {
    var whatsappUrl = "whatsapp://send?phone=$numberPhone";
    return await canLaunch(whatsappUrl) ? launch(whatsappUrl) : false;
  }
}

class Body extends StatefulWidget {
  final ContactsModel contact;

  const Body({Key key, this.contact}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return ExpandableTheme(
      data: const ExpandableThemeData(
        iconColor: Colors.blue,
        useInkWell: true,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackdropAndRating(
              size: size,
              image: widget.contact.image,
            ),
            SizedBox(height: kDefaultPadding / 2),
            TitleAdressName(
              name: widget.contact.name,
              city: widget.contact.address.city,
              neighbourhood: widget.contact.address.neighborhood,
              uf: widget.contact.address.uf,
            ),
            ServiceTypes(servicos: widget.contact.serviceType),
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
                widget.contact.description,
                style: TextStyle(
                  color: kTextLightColor,
                ),
              ),
            ),
            TimeTable(timeTable: widget.contact.timeTable),
          ],
        ),
      ),
    );
  }
}
