import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  AddressModel(
      {this.strAvnName,
      this.number,
      this.state,
      this.neighborhood,
      this.city,
      this.uf,
      this.cep,
      this.country,
      this.compliment,
      this.coordinates});
  String strAvnName,
      number,
      state,
      neighborhood,
      city,
      uf,
      cep,
      country,
      compliment;
  GeoPoint coordinates;

  AddressModel.fromAddress(AddressModel address) {
    this.strAvnName = address.strAvnName;
    this.number = address.number;
    this.state = address.state;
    this.neighborhood = address.neighborhood;
    this.city = address.city;
    this.uf = address.uf;
    this.cep = address.cep;
    this.country = address.country;
    this.compliment = address.compliment;
    this.coordinates = address.coordinates;
  }

  AddressModel.fromFirestore(QueryDocumentSnapshot snapshot) {
    this.strAvnName = snapshot.data()['endereco']['endereco'];
    this.cep = snapshot.data()['endereco']['cep'];
    this.city = snapshot.data()['endereco']['cidade'];
    this.compliment = snapshot.data()['endereco']['complemento'];
    this.country = snapshot.data()['endereco']['pais'];
    this.neighborhood = snapshot.data()['endereco']['bairro'];
    this.number = snapshot.data()['endereco']['numero'];
    this.state = snapshot.data()['endereco']['estado'];
    this.uf = snapshot.data()['endereco']['UF'];
    this.coordinates = snapshot.data()['endereco']['coordenadas'];
  }

  AddressModel.empty() {
    this.strAvnName = '';
    this.number = '';
    this.state = '';
    this.neighborhood = '';
    this.city = '';
    this.uf = '';
    this.cep = '';
    this.country = '';
    this.compliment = '';
    this.coordinates = null;
  }
}
