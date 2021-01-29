import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  String id, title, subtitle, icons, banner;

  CategoriesModel({this.title, this.subtitle, this.icons, this.banner});

  CategoriesModel.fromCategories(CategoriesModel categories) {
    this.id = categories.id;
    this.title = categories.title;
    this.subtitle = categories.subtitle;
    this.icons = categories.icons;
    this.banner = categories.banner;
  }

  CategoriesModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.title = snapshot.data()['titulo'];
    this.subtitle = snapshot.data()['subtitulo'];
    this.icons = snapshot.data()['icone'];
    this.banner = snapshot.data()['banner'];
  }

  CategoriesModel.empty() {
    this.title = '';
    this.subtitle = '';
    this.icons = '';
    this.banner = '';
  }
}
