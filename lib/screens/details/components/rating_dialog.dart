import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/apis/models/rating.dart';
import 'package:AchaFacil/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingDialog extends StatefulWidget {
  final ContactsModel contact;
  final Function(dynamic) callback;

  const RatingDialog({Key key, @required this.contact, this.callback})
      : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _attendanceRating = 3;
  double _priceRating = 3;
  double _qualityRating = 3;
  String _ratingMessage = "";
  bool _progressBarActive = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _canRate = true;
  DateTime _nextRate;

  initState() {
    super.initState();
    checkCache();
  }

  checkCache() async {
    final SharedPreferences prefs = await _prefs;

    if (prefs.getString(widget.contact.id) != null) {
      DateTime lastTimeRated =
          DateTime.parse(prefs.getString(widget.contact.id));
      _nextRate = lastTimeRated.add(Duration(days: daysWaitingRate));
      if (DateTime.now().isBefore(_nextRate)) {
        setState(() {
          _canRate = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.symmetric(
        vertical: kDefaultPadding / 2,
        horizontal: kDefaultPadding,
      ),
      children: [
        Column(
          children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2,
                  horizontal: kDefaultPadding,
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Atendimento:  ",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextSpan(
                        text:
                            widget.contact.rating.attendance.toStringAsFixed(1),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating: _canRate
                        ? _attendanceRating
                        : widget.contact.rating.attendance,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _attendanceRating = rating;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2,
                  horizontal: kDefaultPadding,
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Preço:  ",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextSpan(
                        text: widget.contact.rating.price.toStringAsFixed(1),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating:
                        _canRate ? _priceRating : widget.contact.rating.price,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _priceRating = rating;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            Row(children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2,
                  horizontal: kDefaultPadding,
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Qualidade:  ",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextSpan(
                        text: widget.contact.rating.quality.toStringAsFixed(1),
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating: _canRate
                        ? _qualityRating
                        : widget.contact.rating.quality,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemSize: 30,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _qualityRating = rating;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _canRate
                ? Expanded(
                    child: TextField(
                      onChanged: (value) {
                        _ratingMessage = value;
                      },
                      maxLines: 2,
                      decoration: InputDecoration(
                          labelText: 'Avaliação',
                          hintText: 'ex.: Atendimento excelente'),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: kDefaultPadding),
                      child: Text('próxima avaliação em: ' +
                          _nextRate
                              .difference(DateTime.now())
                              .inDays
                              .toString() +
                          ' dias.'),
                    ),
                  )
          ],
        ),
        Container(height: 20),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _canRate
                    ? ElevatedButton(
                        child: _progressBarActive == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              )
                            : Text('Avaliar'),
                        onPressed: saveRating,
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ],
    );
  }

  void saveRating() async {
    setState(() {
      _progressBarActive = true;
    });

    RatingModel rating = generateRatingMetrics();

    WriteBatch batch = FirebaseFirestore.instance.batch();

    DocumentReference contactDB = FirebaseFirestore.instance
        .collection('contatos')
        .doc(widget.contact.id);

    DocumentReference ratingDB = FirebaseFirestore.instance
        .collection('contatos')
        .doc(widget.contact.id)
        .collection('avaliacoes')
        .doc();

    //Updating the general Rate
    batch.update(contactDB, {
      'avaliacao': {
        'atendimento': num.parse(rating.attendance.toStringAsFixed(1)),
        'geral': num.parse(rating.general.toStringAsFixed(1)),
        'preco': num.parse(rating.price.toStringAsFixed(1)),
        'qualidade': num.parse(rating.quality.toStringAsFixed(1)),
        'quantidade': num.parse(rating.number.toStringAsFixed(0))
      }
    });

    //Posting a single rate in a subcollection
    batch.set(ratingDB, {
      'atendimento': num.parse(_attendanceRating.toStringAsFixed(1)),
      'preco': num.parse(_priceRating.toStringAsFixed(1)),
      'qualidade': num.parse(_qualityRating.toStringAsFixed(1)),
      'mensagem': _ratingMessage,
      'data': DateTime.now()
    });

    batch
        .commit()
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Avaliação enviada com sucesso.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ))
        .then((value) {
          setState(() {
            _progressBarActive = false;
            widget.contact.rating = rating;
          });

          saveRatingCache(widget.contact.id);

          widget.callback(rating);
          Navigator.of(context).pop();
        })
        .catchError((error) => print(error))
        .then((value) => setState(() {
              _progressBarActive = false;
            }));
  }

  RatingModel generateRatingMetrics() {
    //Formula
    //((Overall Rating * Total Rating) + new Rating) / (Total Rating + 1)
    RatingModel rating = RatingModel(
        attendance:
            ((widget.contact.rating.attendance * widget.contact.rating.number) +
                    _attendanceRating) /
                (widget.contact.rating.number + 1),
        price: ((widget.contact.rating.price * widget.contact.rating.number) +
                _priceRating) /
            (widget.contact.rating.number + 1),
        quality:
            ((widget.contact.rating.quality * widget.contact.rating.number) +
                    _qualityRating) /
                (widget.contact.rating.number + 1),
        general:
            ((widget.contact.rating.general * widget.contact.rating.number) +
                    ((_qualityRating + _priceRating + _attendanceRating) / 3)) /
                (widget.contact.rating.number + 1),
        number: widget.contact.rating.number + 1);

    return rating;
  }

  void saveRatingCache(String id) async {
    final SharedPreferences prefs = await _prefs;
    //save the rating day for this contact
    prefs.setString(
        id,
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString());
  }
}
