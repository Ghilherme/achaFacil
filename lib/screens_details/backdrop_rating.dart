import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:AchaFacil/constants.dart';

class BackdropAndRating extends StatefulWidget {
  const BackdropAndRating({
    Key key,
    @required this.size,
    @required this.imageBanner,
    this.imageAvatar,
    this.scheduleType,
  }) : super(key: key);

  final Size size;
  final String imageBanner, imageAvatar, scheduleType;

  @override
  _BackdropAndRatingState createState() => _BackdropAndRatingState();
}

class _BackdropAndRatingState extends State<BackdropAndRating> {
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
                  image:
                      widget.imageBanner == null || widget.imageBanner.isEmpty
                          ? AssetImage('assets/images/in_construction.jpg')
                          : Image.network(widget.imageBanner).image),
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
                              backgroundImage: widget.imageAvatar == '' ||
                                      widget.imageAvatar == null
                                  ? AssetImage('assets/images/contacts.jpeg')
                                  : Image.network(widget.imageAvatar).image),
                        ]),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/star_fill.svg"),
                        SizedBox(height: kDefaultPadding / 4),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: '5/',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: "5\n"),
                              TextSpan(
                                text: "de 120",
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
                        renderScheduleType(widget.scheduleType),
                        SizedBox(height: kDefaultPadding / 4),
                        Text(
                          "Funcionamento",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.scheduleType,
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
          // Back Button
          SafeArea(
              child: BackButton(
            color: Colors.white,
          )),
        ],
      ),
    );
  }

  Widget renderScheduleType(String scheduleType) {
    if (widget.scheduleType == schedule[0]) //Atende Emergências
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
    else if (widget.scheduleType == schedule[1]) //Comercial
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
    else if (widget.scheduleType == schedule[2]) //Com agendamento
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
}
