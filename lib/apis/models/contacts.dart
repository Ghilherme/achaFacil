import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactsModel {
  ContactsModel(
      {@required this.name,
      @required this.email,
      @required this.description,
      @required this.serviceType,
      @required this.site,
      @required this.telNumbers,
      @required this.address,
      this.id});
  String id, name, email, description, site;
  Map<String, String> telNumbers;
  List<dynamic> serviceType;
  Address address;

  ContactsModel.fromContact(ContactsModel contact) {
    this.id = contact.id;
    this.description = contact.description;
    this.email = contact.email;
    this.name = contact.name;
    this.serviceType = contact.serviceType;
    this.site = contact.site;
    this.telNumbers = contact.telNumbers;
    this.address = contact.address;
  }
  ContactsModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.name = snapshot.data()['nome'];
    this.email = snapshot.data()['email'];
    this.description = snapshot.data()['descricao'];
    this.serviceType = snapshot.data()['servicos'];
    this.site = snapshot.data()['site'];
    this.telNumbers = {'whatsapp': snapshot.data()['telefone1']['whatsapp']};
    this.address = Address(
        strAvnName: snapshot.data()['endereco']['endereco'],
        cep: snapshot.data()['endereco']['cep'],
        city: snapshot.data()['endereco']['cidade'],
        compliment: snapshot.data()['endereco']['complemento'],
        country: snapshot.data()['endereco']['pais'],
        neighborhood: snapshot.data()['endereco']['bairro'],
        number: snapshot.data()['endereco']['numero'],
        state: snapshot.data()['endereco']['estado'],
        uf: snapshot.data()['endereco']['UF']);
  }

  ContactsModel.empty() {
    this.description = '';
    this.email = '';
    this.name = '';
    this.serviceType = List<dynamic>();
    this.site = '';
    this.telNumbers = Map<String, String>();
    this.address = Address.empty();
  }
}

class Address {
  Address(
      {this.strAvnName,
      this.number,
      this.state,
      this.neighborhood,
      this.city,
      this.uf,
      this.cep,
      this.country,
      this.compliment});
  String strAvnName,
      number,
      state,
      neighborhood,
      city,
      uf,
      cep,
      country,
      compliment;

  Address.fromAddress(Address address) {
    this.strAvnName = address.strAvnName;
    this.number = address.number;
    this.state = address.state;
    this.neighborhood = address.neighborhood;
    this.city = address.city;
    this.uf = address.uf;
    this.cep = address.cep;
    this.country = address.country;
    this.compliment = address.compliment;
  }

  Address.empty() {
    this.strAvnName = '';
    this.number = '';
    this.state = '';
    this.neighborhood = '';
    this.city = '';
    this.uf = '';
    this.cep = '';
    this.country = '';
    this.compliment = '';
  }
}
