import 'package:listaUnica/apis/models/service_type.dart';

class Contacts {
  final String name, number;
  final List<ServiceType> serviceType;

  // ignore: sort_constructors_first
  Contacts({this.name, this.number, this.serviceType});
}

List<Contacts> contacts = [
  Contacts(
      name: 'José Monteiro',
      number: '11959369148',
      serviceType: services.where((x) => x.id == 1).toList()),
  Contacts(
      name: 'Josias Neves',
      number: '11989139148',
      serviceType: services.where((x) => x.id == 1).toList()),
  Contacts(
      name: 'José João Candido',
      number: '11912354543',
      serviceType: services.where((x) => x.id == 3).toList()),
];
