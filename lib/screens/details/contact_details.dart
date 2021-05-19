import 'package:AchaFacil/apis/gets.dart';
import 'package:AchaFacil/components/card_icon.dart';
import 'package:AchaFacil/components/expandable_widget.dart';
import 'package:AchaFacil/models/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:expandable/expandable.dart';
import 'components/card_header.dart';
import 'components/genres.dart';
import 'components/title_address_name.dart';

class ContactDetails extends StatelessWidget {
  ContactDetails({Key key, @required this.contact}) : super(key: key);
  final ContactsModel contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContactBody(contact: contact),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Gets.launchExternal("whatsapp://send?phone=" +
                  contact.telNumbers['whatsapp'] +
                  '&text=' +
                  Uri.encodeFull(whatsMessageContact))
              .then((launched) {
            if (launched)
              increaseTagCount(contact.id, contact.zapClickedAmount);
            else
              Gets.launchExternal(
                      "https://wa.me/${contact.telNumbers['whatsapp']}/?text=${Uri.encodeFull(whatsMessageContact)}")
                  .then((launched) {
                if (launched)
                  increaseTagCount(contact.id, contact.zapClickedAmount);
              });
          });
        },
        label: Text('Zap'),
        icon: Icon(Icons.call),
      ),
    );
  }

  void increaseTagCount(String id, int zapClickedAmount) {
    DocumentReference contactDB =
        FirebaseFirestore.instance.collection('contatos').doc(id);
    int zap = zapClickedAmount == null ? 1 : zapClickedAmount + 1;
    contactDB.update({'zapclicado': zap});
    contact.zapClickedAmount = zap;
  }
}

class ContactBody extends StatefulWidget {
  final ContactsModel contact;

  const ContactBody({Key key, this.contact}) : super(key: key);

  @override
  _ContactBodyState createState() => _ContactBodyState();
}

class _ContactBodyState extends State<ContactBody> {
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
            CardHeader(
              size: size,
              contact: widget.contact,
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
                      icon: Icons.language,
                      title: widget.contact.site,
                    )),
            widget.contact.email.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                        icon: Icons.email, title: widget.contact.email)),
            widget.contact.timeTable.values.every((element) => element == '')
                ? Container()
                : TimeTable(timeTable: widget.contact.timeTable),
            widget.contact.instagram == null || widget.contact.instagram.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                      imagePath: 'assets/icons/instagram_logo.png',
                      title: widget.contact.instagram,
                      onTap: () async {
                        if (widget.contact.instagram.contains('.com'))
                          Gets.launchExternal(widget.contact.instagram.trim());
                        else
                          Gets.launchExternal('https://www.instagram.com/' +
                              widget.contact.instagram);
                      },
                    )),
            widget.contact.facebook == null || widget.contact.facebook.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                        imagePath: 'assets/icons/facebook_logo.png',
                        title: widget.contact.facebook,
                        onTap: () async {
                          if (widget.contact.facebook.contains('.com'))
                            Gets.launchExternal(widget.contact.facebook.trim());
                          else
                            Gets.launchExternal('https://www.facebook.com/' +
                                widget.contact.facebook);
                        }),
                  ),
            widget.contact.linkedin == null || widget.contact.linkedin.isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                    child: CardIcon(
                        imagePath: 'assets/icons/linkedin_logo.png',
                        title: widget.contact.linkedin,
                        onTap: () async {
                          if (widget.contact.linkedin.contains('.com'))
                            Gets.launchExternal(widget.contact.linkedin.trim());
                          else
                            Gets.launchExternal('https://www.linkedin.com/in/' +
                                widget.contact.linkedin);
                        })),
            Container(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
