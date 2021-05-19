import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  double attendance, general, price, quality, number;

  RatingModel(
      {this.attendance, this.general, this.price, this.quality, this.number});

  RatingModel.fromRating(RatingModel rating) {
    this.attendance = rating.attendance;
    this.general = rating.general;
    this.price = rating.price;
    this.quality = rating.quality;
    this.number = rating.number;
  }

  RatingModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    if (snapshot.data().containsKey('avaliacao')) {
      this.attendance = snapshot.data()['avaliacao']['atendimento'].toDouble();
      this.general = snapshot.data()['avaliacao']['geral'].toDouble();
      this.price = snapshot.data()['avaliacao']['preco'].toDouble();
      this.quality = snapshot.data()['avaliacao']['qualidade'].toDouble();
      this.number = snapshot.data()['avaliacao']['quantidade'].toDouble();
    } else {
      this.attendance = 0.0;
      this.general = 0.0;
      this.price = 0.0;
      this.quality = 0.0;
      this.number = 0;
    }
  }

  RatingModel.empty() {
    this.attendance = 0.0;
    this.general = 0.0;
    this.price = 0.0;
    this.quality = 0.0;
    this.number = 0;
  }
}
