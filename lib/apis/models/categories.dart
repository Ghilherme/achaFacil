import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  String id, title, subtitle, icons;

  CategoriesModel({this.title, this.subtitle, this.icons});

  CategoriesModel.fromCategories(CategoriesModel categories) {
    this.id = categories.id;
    this.title = categories.title;
    this.subtitle = categories.subtitle;
    this.icons = categories.icons;
  }

  CategoriesModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.title = snapshot.data()['titulo'];
    this.subtitle = snapshot.data()['subtitulo'];
    this.icons = snapshot.data()['icone'];
  }

  CategoriesModel.empty() {
    this.title = '';
    this.subtitle = '';
    this.icons = '';
  }
}
