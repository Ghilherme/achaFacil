import 'package:flutter/material.dart';

class Contacts {
  const Contacts(
      {@required this.address,
      @required this.email,
      @required this.telNumbers,
      @required this.description,
      @required this.name,
      @required this.serviceType});
  final String name, email, description;
  final Map<String, String> telNumbers;
  final List<String> serviceType;
  final Address address;
}

class Address {
  final String strAvnName, number, state, neighborhood, city, uf, cep, country;

  Address(this.strAvnName, this.number, this.state, this.neighborhood,
      this.city, this.uf, this.cep, this.country);
}
