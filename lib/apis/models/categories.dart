import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/service_type.dart';

class Categories {
  final String categorieName, subtitleCategorieName;
  final Icon icons;
  final List<ServiceType> serviceType;

  Categories({
    this.categorieName,
    this.subtitleCategorieName,
    this.icons,
    this.serviceType,
  });
}

List<Categories> categories = [
  Categories(
      categorieName: 'Reformas e Reparos',
      subtitleCategorieName: 'Encanadores, pintores, eletricistas',
      icons: Icon(Icons.build),
      serviceType: services
          .where((x) => x.categorieName == 'Reformas e Reparos')
          .toList()),
  Categories(
      categorieName: 'Construção',
      subtitleCategorieName: 'Pedreiros, arquitetos, pós obra',
      icons: Icon(Icons.construction),
      serviceType:
          services.where((x) => x.categorieName == 'Construção').toList()),
  Categories(
      categorieName: 'Serviços Gerais',
      subtitleCategorieName: 'Marceneiros, chaveiros',
      icons: Icon(Icons.cleaning_services),
      serviceType:
          services.where((x) => x.categorieName == 'Serviços Gerais').toList()),
  Categories(
      categorieName: 'Instalação',
      subtitleCategorieName: 'TVs, Antenas',
      icons: Icon(Icons.build_circle),
      serviceType:
          services.where((x) => x.categorieName == 'Instalação').toList()),
  Categories(
      categorieName: 'Serviços de Emergência',
      subtitleCategorieName: 'Atendimento 24hrs',
      icons: Icon(Icons.add_alert),
      serviceType:
          services.where((x) => x.categorieName == 'Instalação').toList()),
];
