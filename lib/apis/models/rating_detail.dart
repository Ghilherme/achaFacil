import 'package:cloud_firestore/cloud_firestore.dart';

class RatingDetailModel {
  double attendance, price, quality;
  String message;
  DateTime dateTime;

  RatingDetailModel(
      {this.attendance, this.price, this.quality, this.message, this.dateTime});

  RatingDetailModel.fromRating(RatingDetailModel rating) {
    this.attendance = rating.attendance;
    this.price = rating.price;
    this.quality = rating.quality;
    this.message = rating.message;
    this.dateTime = rating.dateTime;
  }

  RatingDetailModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.attendance = snapshot.data()['atendimento'].toDouble();
    this.price = snapshot.data()['preco'].toDouble();
    this.quality = snapshot.data()['qualidade'].toDouble();
    this.message = snapshot.data()['mensagem'];
    this.dateTime = snapshot.data()['data'] == null
        ? null
        : snapshot.data()['data'].toDate();
  }

  RatingDetailModel.empty() {
    this.attendance = 0.0;
    this.price = 0.0;
    this.quality = 0.0;
    this.message = '';
    this.dateTime = null;
  }
}
