import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/card_icon.dart';
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
              imageBanner: widget.contact.image,
              imageAvatar: widget.contact.imageAvatar,
              scheduleType: widget
                  .contact.scheduleType[0], // only one scheduleType for now..
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
                style: TextStyle(color: kTextLightColor),
              ),
            ),
            widget.contact.address.strAvnName.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                        icon: Icons.room,
                        title: widget.contact.address.strAvnName +
                            ', ' +
                            widget.contact.address.number +
                            ' ' +
                            widget.contact.address.compliment)),
            widget.contact.site.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                        icon: Icons.language, title: widget.contact.site)),
            widget.contact.email.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                        icon: Icons.email, title: widget.contact.email)),
            TimeTable(timeTable: widget.contact.timeTable),
          ],
        ),
      ),
    );
  }
}
