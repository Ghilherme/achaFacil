import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';

class RatingDialog extends StatefulWidget {
  final ContactsModel contact;

  const RatingDialog({Key key, @required this.contact}) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _attendanceRating = 3;
  double _priceRating = 3;
  double _qualityRating = 3;
  String _rating = "";
  bool _progressBarActive = false;

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
                child: Text(
                  "Atendimento:",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating: _attendanceRating,
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
                child: Text(
                  "Preço:",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating: _priceRating,
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
                child: Text(
                  "Qualidade:",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar.builder(
                    initialRating: _qualityRating,
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
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  _rating = value;
                },
                maxLines: 2,
                decoration: InputDecoration(
                    labelText: 'Avaliação',
                    hintText: 'ex.: Atendimento excelente'),
              ),
            ),
          ],
        ),
        Container(height: 20),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: _progressBarActive == true
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                      : Text('Avaliar'),
                  onPressed: saveRating,
                ),
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
    print('atendimento:' + _attendanceRating.toString());
    print('Preços:' + _priceRating.toString());
    print('quality:' + _qualityRating.toString());

    print('avaliação: ' + _rating);

    //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
    DocumentReference contactDB = FirebaseFirestore.instance
        .collection('contatos')
        .doc(widget.contact.id);

    setState(() {
      _progressBarActive = false;
    });
  }
}
