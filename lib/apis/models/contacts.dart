import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'address.dart';
import 'rating.dart';

class ContactsModel {
  ContactsModel(
      {@required this.name,
      @required this.email,
      @required this.description,
      @required this.serviceType,
      @required this.site,
      @required this.telNumbers,
      @required this.scheduleType,
      @required this.address,
      this.rating,
      this.image,
      this.imageAvatar,
      this.timeTable,
      this.id,
      this.lastModification,
      this.createdAt,
      this.zapClickedAmount,
      this.instagram,
      this.facebook,
      this.linkedin});
  String id,
      name,
      email,
      description,
      site,
      image,
      imageAvatar,
      instagram,
      facebook,
      linkedin;
  Map<String, dynamic> telNumbers, timeTable;
  List<dynamic> serviceType, scheduleType;
  AddressModel address;
  RatingModel rating;
  DateTime lastModification, createdAt;
  int zapClickedAmount;

  ContactsModel.fromContact(ContactsModel contact) {
    this.id = contact.id;
    this.name = contact.name;
    this.email = contact.email;
    this.description = contact.description;
    this.serviceType = contact.serviceType;
    this.site = contact.site;
    this.telNumbers = contact.telNumbers;
    this.scheduleType = contact.scheduleType;
    this.timeTable = contact.timeTable;
    this.address = contact.address;
    this.image = contact.image;
    this.imageAvatar = contact.imageAvatar;
    this.lastModification = contact.lastModification;
    this.createdAt = contact.createdAt;
    this.rating = contact.rating;
    this.zapClickedAmount = contact.zapClickedAmount;
    this.instagram = contact.instagram;
    this.facebook = contact.facebook;
    this.linkedin = contact.linkedin;
  }
  ContactsModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.data()['nome'];
    this.email = snapshot.data()['email'];
    this.description = snapshot.data()['descricao'];
    this.serviceType = snapshot.data()['servicos'];
    this.site = snapshot.data()['site'];
    this.telNumbers = Map<String, dynamic>.from(snapshot.data()['telefone1']);
    this.scheduleType = snapshot.data()['funcionamento'];
    this.timeTable = Map<String, dynamic>.from(snapshot.data()['horarios']);
    this.address = AddressModel.fromFirestore(snapshot);
    this.image = snapshot.data()['imagem'];
    this.imageAvatar = snapshot.data()['avatar'];
    this.lastModification = snapshot.data()['atualizacao'] == null
        ? null
        : snapshot.data()['atualizacao'].toDate();
    this.createdAt = snapshot.data()['criacao'] == null
        ? null
        : snapshot.data()['criacao'].toDate();
    this.rating = RatingModel.fromFirestore(snapshot);
    this.zapClickedAmount = snapshot.data()['zapclicado'];
    this.instagram = snapshot.data()['instagram'];
    this.facebook = snapshot.data()['facebook'];
    this.linkedin = snapshot.data()['linkedin'];
  }

  ContactsModel.empty() {
    this.name = '';
    this.email = '';
    this.description = '';
    this.serviceType = List<dynamic>();
    this.site = '';
    this.telNumbers = Map<String, dynamic>();
    this.scheduleType = [''];
    this.timeTable = Map<String, dynamic>();
    this.address = AddressModel.empty();
    this.image = '';
    this.imageAvatar = '';
    this.lastModification = null;
    this.createdAt = null;
    this.rating = RatingModel.empty();
    this.zapClickedAmount = 0;
    this.instagram = '';
    this.facebook = '';
    this.linkedin = '';
  }
}
