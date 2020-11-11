import 'package:flutter/material.dart';

class Contacts {
  Contacts(
      {@required this.address,
      @required this.email,
      @required this.telNumbers,
      @required this.description,
      @required this.name,
      @required this.serviceType,
      @required this.site,
      this.id});
  String id, name, email, description, site;
  Map<String, String> telNumbers;
  List<dynamic> serviceType;
  Address address;

  Contacts.fromContact(Contacts contact) {
    this.id = contact.id;
    this.description = contact.description;
    this.email = contact.email;
    this.name = contact.name;
    this.serviceType = contact.serviceType;
    this.site = contact.site;
    this.telNumbers = contact.telNumbers;
    this.address = contact.address;
  }

  Contacts.empty() {
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
