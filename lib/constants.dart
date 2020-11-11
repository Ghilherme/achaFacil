import 'package:flutter/material.dart';

import 'apis/models/states.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);

const kDefaultPaddin = 20.0;

// Colos that use in our app
const kSecondaryColor = Color(0xFFFE6D8E);
const kFillStarColor = Color(0xFFFCC419);

const kDefaultPadding = 20.0;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);

List<States> statesList = [
  States(state: 'Acre', uf: 'AC'),
  States(state: 'Alagoas', uf: 'AL'),
  States(state: 'Amapá', uf: 'AP'),
  States(state: 'Amazonas', uf: 'AM'),
  States(state: 'Bahia', uf: 'BA'),
  States(state: 'Ceará', uf: 'CE'),
  States(state: 'Distrito Federal', uf: 'DF'),
  States(state: 'Espírito Santo', uf: 'ES'),
  States(state: 'Goiás', uf: 'GO'),
  States(state: 'Maranhão', uf: 'MA'),
  States(state: 'Mato Grosso', uf: 'MT'),
  States(state: 'Mato Grosso do Sul ', uf: 'MS'),
  States(state: 'Minas Gerais', uf: 'MG'),
  States(state: 'Pará', uf: 'PA'),
  States(state: 'Paraíba', uf: 'PB'),
  States(state: 'Paraná', uf: 'PR'),
  States(state: 'Pernambuco', uf: 'PE'),
  States(state: 'Piauí', uf: 'PI'),
  States(state: 'Rio de Janeiro', uf: 'RJ'),
  States(state: 'Rio Grande do Norte', uf: 'RN'),
  States(state: 'Rio Grande do Sul', uf: 'RS'),
  States(state: 'Rondônia', uf: 'RO'),
  States(state: 'Roraima', uf: 'RR'),
  States(state: 'Santa Catarina   ', uf: 'SC'),
  States(state: 'São Paulo', uf: 'SP'),
  States(state: 'Sergipe', uf: 'SE'),
  States(state: 'Tocantins', uf: 'TO'),
];
