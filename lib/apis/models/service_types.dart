import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ServiceTypesModel {
  ServiceTypesModel(
      {@required this.name, @required this.categoryTitle, this.id});
  String id, name, categoryTitle;

  ServiceTypesModel.fromServiceType(ServiceTypesModel serviceType) {
    this.id = serviceType.id;
    this.name = serviceType.name;
    this.categoryTitle = serviceType.categoryTitle;
  }
  ServiceTypesModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.data()['nome'];
    this.categoryTitle = snapshot.data()['titulo_categoria'];
  }

  ServiceTypesModel.empty() {
    this.name = '';
    this.categoryTitle = '';
  }
}
