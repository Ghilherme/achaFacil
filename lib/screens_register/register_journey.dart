import 'dart:io';
import 'package:AchaFacil/apis/models/contacts_status.dart';
import 'package:AchaFacil/screens_register/personal_step.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:geocoding/geocoding.dart';
import '../constants.dart';
import 'attendance_step.dart';
import 'end_journey.dart';
import 'region_step.dart';

class RegisterJourney extends StatelessWidget {
  const RegisterJourney({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Cadastro'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: RegisterJourneyBody(),
    );
  }
}

class RegisterJourneyBody extends StatefulWidget {
  @override
  _RegisterJourneyBodyState createState() => _RegisterJourneyBodyState();
}

class _RegisterJourneyBodyState extends State<RegisterJourneyBody> {
  final ContactsModel contact = ContactsModel.empty();
  var _currentStep = 0;
  bool _progressBarActive = false;
  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text('Profissional'),
        content: ProfessionalStep(contact: contact),
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Atendimento'),
        content: AttendanceStep(contact: contact),
        state: _currentStep == 1
            ? StepState.editing
            : _currentStep == 2
                ? StepState.complete
                : StepState.indexed,
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Região'),
        content: RegionStep(contact: contact),
        state: _currentStep == 2 ? StepState.editing : StepState.indexed,
        isActive: _currentStep >= 2,
      ),
    ];
    return Container(
        child: Stepper(
      currentStep: this._currentStep,
      steps: steps,
      type: StepperType.horizontal,
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _currentStep != 0
                  ? FlatButton(
                      textColor: kTextLightColor,
                      child: Text('Cancelar'),
                      onPressed: onStepCancel)
                  : Container(),
              ElevatedButton(
                  onPressed: onStepContinue,
                  child: _progressBarActive
                      ? Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ))
                      : _currentStep == 2
                          ? Row(
                              children: [Text('Solicitar '), Icon(Icons.save)],
                            )
                          : Row(
                              children: [
                                Text('Continuar'),
                                Icon(Icons.navigate_next)
                              ],
                            )),
            ],
          ),
        );
      },
      /* onStepTapped: (value) {
        setState(() {
          _currentStep = value;
        });
      } ,*/
      onStepContinue: () {
        if (_currentStep < steps.length - 1) {
          if (_currentStep == 0 &&
              ProfessionalStepState.formKey.currentState.validate()) {
            setState(() {
              _currentStep = _currentStep + 1;
            });
          } else if (_currentStep == 1 &&
              AttendanceStepState.formKey.currentState.validate()) {
            setState(() {
              _currentStep = _currentStep + 1;
            });
          }
        } else if (_currentStep == 2 &&
            RegionStepState.formKey.currentState.validate()) {
          requestContact();
        }
      },
      onStepCancel: () {
        setState(() {
          if (_currentStep > 0) {
            _currentStep = _currentStep - 1;
          } else {
            _currentStep = 0;
          }
        });
      },
    ));
  }

  Future<String> uploadFileImage(String refPath, String filePath) async {
    File file = File(filePath);

    await FirebaseStorage.instance.ref(refPath).putFile(file);
    return await FirebaseStorage.instance.ref(refPath).getDownloadURL();
  }

  void requestContact() async {
    setState(() {
      _progressBarActive = true;
    });

    //cria um ID novo
    DocumentReference contactDB =
        FirebaseFirestore.instance.collection('contatos').doc();

    //Se houve alteração na imagem, faz um novo upload
    if (contact.image.isNotEmpty)
      contact.image = await uploadFileImage(
          'uploads/' + contactDB.id + '/' + contactDB.id + '_background.png',
          contact.image);

    if (contact.imageAvatar.isNotEmpty)
      contact.imageAvatar = await uploadFileImage(
          'uploads/' + contactDB.id + '/' + contactDB.id + '_avatar.png',
          contact.imageAvatar);

    if (contact.createdAt == null) contact.createdAt = DateTime.now();

    contact.lastModification = DateTime.now();

    //tenta pegar geopoint com endereço providenciado, senão pega da localização atual
    try {
      await locationFromAddress(contact.address.strAvnName +
              ' ' +
              contact.address.number +
              ',' +
              contact.address.neighborhood +
              ',' +
              contact.address.city)
          .then((value) => contact.address.coordinates =
              GeoPoint(value.first.latitude, value.first.longitude));
    } catch (e) {
      contact.address.coordinates =
          GeoPoint(globalPosition.latitude, globalPosition.longitude);
    }

    //Solicitação sempre criada como pendente
    contact.status = Status.pending;

    contactDB
        .set({
          'nome': contact.name,
          'email': contact.email,
          'descricao': contact.description,
          'servicos': contact.serviceType,
          'site': contact.site,
          'telefone1': contact.telNumbers,
          'imagem': contact.image,
          'avatar': contact.imageAvatar,
          'horarios': contact.timeTable,
          'funcionamento': contact.scheduleType,
          'atualizacao': contact.lastModification,
          'criacao': contact.createdAt,
          'instagram': contact.instagram,
          'facebook': contact.facebook,
          'linkedin': contact.linkedin,
          'status': contact.status,
          'radarkms': contact.regionAttendanceRadar,
          'endereco': {
            'endereco': contact.address.strAvnName,
            'complemento': contact.address.compliment,
            'numero': contact.address.number,
            'bairro': contact.address.neighborhood,
            'cidade': contact.address.city,
            'estado': contact.address.state,
            'UF': contact.address.uf,
            'coordenadas': contact.address.coordinates,
          },
          'avaliacao': {
            'atendimento': contact.rating.attendance,
            'geral': contact.rating.general,
            'preco': contact.rating.price,
            'qualidade': contact.rating.quality,
            'quantidade': contact.rating.number,
          }
        })
        .then((value) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Solicitação enviada com sucesso.'),
                  content: Text('A aprovação será feita em até 48 horas.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ))
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EndJourney()),
          ),
        )
        .catchError((error) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Ops... Falha ao enviar a solicitação.'),
                content: Text(
                    'Houve algum erro ao enviar a solicitação. Tente enviar novamente, caso o erro persista, tente mais tarde.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            _progressBarActive = false;
          });
        });
  }
}
