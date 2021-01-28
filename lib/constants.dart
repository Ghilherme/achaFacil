import 'package:AchaFacil/apis/models/weekdays.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'apis/models/states.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);

const String mainTitleApp = 'Acha Fácil!';
const String urlAvatarInitials =
    'https://ui-avatars.com/api/?background=random&name=';

// Colos that use in our app
const kFillStarColor = Color(0xFFFCC419);

const kDefaultPadding = 20.0;
const daysWaitingRate = 7;
const kDefaultPaddingListView = 5.0;

Position globalPosition;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 4),
  blurRadius: 4,
  color: Colors.black26,
);

const List<States> statesList = const [
  const States(state: 'Acre', uf: 'AC'),
  const States(state: 'Alagoas', uf: 'AL'),
  const States(state: 'Amapá', uf: 'AP'),
  const States(state: 'Amazonas', uf: 'AM'),
  const States(state: 'Bahia', uf: 'BA'),
  const States(state: 'Ceará', uf: 'CE'),
  const States(state: 'Distrito Federal', uf: 'DF'),
  const States(state: 'Espírito Santo', uf: 'ES'),
  const States(state: 'Goiás', uf: 'GO'),
  const States(state: 'Maranhão', uf: 'MA'),
  const States(state: 'Mato Grosso', uf: 'MT'),
  const States(state: 'Mato Grosso do Sul ', uf: 'MS'),
  const States(state: 'Minas Gerais', uf: 'MG'),
  const States(state: 'Pará', uf: 'PA'),
  const States(state: 'Paraíba', uf: 'PB'),
  const States(state: 'Paraná', uf: 'PR'),
  const States(state: 'Pernambuco', uf: 'PE'),
  const States(state: 'Piauí', uf: 'PI'),
  const States(state: 'Rio de Janeiro', uf: 'RJ'),
  const States(state: 'Rio Grande do Norte', uf: 'RN'),
  const States(state: 'Rio Grande do Sul', uf: 'RS'),
  const States(state: 'Rondônia', uf: 'RO'),
  const States(state: 'Roraima', uf: 'RR'),
  const States(state: 'Santa Catarina   ', uf: 'SC'),
  const States(state: 'São Paulo', uf: 'SP'),
  const States(state: 'Sergipe', uf: 'SE'),
  const States(state: 'Tocantins', uf: 'TO'),
];

const List<WeekDays> weekDays = const [
  const WeekDays(dayName: 'Segunda-feira', dayNumber: 1),
  const WeekDays(dayName: 'Terça-feira', dayNumber: 2),
  const WeekDays(dayName: 'Quarta-feira', dayNumber: 3),
  const WeekDays(dayName: 'Quinta-feira', dayNumber: 4),
  const WeekDays(dayName: 'Sexta-feira', dayNumber: 5),
  const WeekDays(dayName: 'Sábado', dayNumber: 6),
  const WeekDays(dayName: 'Domingo', dayNumber: 7),
];

const List<String> schedule = const [
  'Atende Emergências',
  'Comercial',
  'Com Agendamento'
];
