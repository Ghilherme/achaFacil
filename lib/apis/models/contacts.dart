import 'package:flutter/material.dart';

class Contacts {
  Contacts(
      {@required this.address,
      @required this.email,
      @required this.telNumbers,
      @required this.description,
      @required this.name,
      @required this.serviceType});
  String name, email, description, site;
  Map<String, String> telNumbers;
  List<dynamic> serviceType;
  Address address;
}

class Address {
  String strAvnName,
      number,
      state,
      neighborhood,
      city,
      uf,
      cep,
      country,
      compliment;

  Address(this.strAvnName, this.number, this.state, this.neighborhood,
      this.city, this.uf, this.cep, this.country, this.compliment);
}
