import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/screens_details/rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:AchaFacil/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardHeader extends StatefulWidget {
  const CardHeader({
    Key key,
    this.contact,
    @required this.size,
  }) : super(key: key);

  final ContactsModel contact;
  final Size size;

  @override
  _CardHeaderState createState() => _CardHeaderState(contact.scheduleType[0]);
}

class _CardHeaderState extends State<CardHeader> {
  _CardHeaderState(this.scheduleType);
  final String scheduleType;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _favorited = false;
  List<String> _favoritesCache = List<String>();

  initState() {
    super.initState();
    checkCache();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 40% of our total height
      height: widget.size.height * 0.4,
      child: Stack(
        children: <Widget>[
          Container(
            height: widget.size.height * 0.4 - 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.contact.image == null ||
                          widget.contact.image.isEmpty
                      ? AssetImage('assets/images/banner.png')
                      : Image.network(widget.contact.image).image),
            ),
          ),
          // Rating Box
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              // it will cover 90% of our total width
              width: widget.size.width * 0.9,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  topLeft: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 50,
                    color: Color(0xFF12153D).withOpacity(0.2),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 35,
                              backgroundImage: widget.contact.imageAvatar ==
                                          '' ||
                                      widget.contact.imageAvatar == null
                                  ? Image.network(urlAvatarInitials +
                                          widget.contact.name)
                                      .image
                                  : Image.network(widget.contact.imageAvatar)
                                      .image),
                        ]),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: SvgPicture.asset("assets/icons/star_fill.svg"),
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return RatingDialog(
                                contact: widget.contact,
                                callback: callbackRating,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: kDefaultPadding / 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: widget.contact.rating.general
                                        .toStringAsFixed(1) +
                                    "/",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: "5\n"),
                              TextSpan(
                                text: "  de " +
                                    widget.contact.rating.number
                                        .toStringAsFixed(0),
                                style: TextStyle(
                                    fontSize: 11, color: kTextLightColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        renderScheduleType(scheduleType),
                        SizedBox(height: kDefaultPadding / 4),
                        Text(
                          "Funcionamento",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          scheduleType,
                          style:
                              TextStyle(fontSize: 12, color: kTextLightColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            height: widget.size.height * 0.13,
            width: double.infinity,
            child: IconButton(
              icon: Icon(Icons.favorite),
              color: _favorited ? Colors.red : Colors.grey,
              onPressed: () async {
                saveFavoritedCache(widget.contact.createdAt);
              },
            ),
          ),
          // Back Button
          SafeArea(
              child: BackButton(
            color: Colors.white,
          )),
        ],
      ),
    );
  }

  callbackRating(rating) {
    setState(() {
      widget.contact.rating = rating;
    });
  }

  Widget renderScheduleType(String scheduleType) {
    if (scheduleType == schedule[0]) //Atende Emergências
      return Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(0xFF51CF66),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          '24hrs',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    else if (scheduleType == schedule[1]) //Comercial
      return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(
            Icons.business,
            color: Colors.white,
          ));
    else if (scheduleType == schedule[2]) //Com agendamento
      return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Icon(
            Icons.schedule,
            color: Colors.white,
          ));

    return Container();
  }

  checkCache() async {
    //using field createdAt to store the favorites in cache
    final SharedPreferences prefs = await _prefs;
    List<String> cacheFavorites = prefs.getStringList('favoritos');

    if (cacheFavorites != null) {
      _favoritesCache = cacheFavorites;
      if (cacheFavorites.contains(widget.contact.createdAt.toString()))
        setState(() {
          _favorited = true;
        });
    }
  }

  saveFavoritedCache(DateTime createdAt) async {
    //using field createdAt to store the favorites in cache
    final SharedPreferences prefs = await _prefs;
    List<String> cacheFavorites = prefs.getStringList('favoritos');

    if (cacheFavorites != null && cacheFavorites.contains(createdAt.toString()))
      _favoritesCache.remove(createdAt.toString());
    else
      _favoritesCache.add(createdAt.toString());

    prefs.setStringList('favoritos', _favoritesCache);
    setState(() {
      _favorited = !_favorited;
    });
  }
}
