import 'dart:io';
import 'package:AchaFacil/components/image_picker.dart';
import 'package:AchaFacil/components/timetable_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/apis/models/states.dart';
import 'package:geocoding/geocoding.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../constants.dart';

class CreateContact extends StatelessWidget {
  final ContactsModel contact;

  const CreateContact({Key key, this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Criar Contato'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: CreateContactBody(contact),
    );
  }
}

class CreateContactBody extends StatefulWidget {
  CreateContactBody(this.contact);
  final ContactsModel contact;

  @override
  _CreateContactBodyState createState() =>
      _CreateContactBodyState(this.contact);
}

class _CreateContactBodyState extends State<CreateContactBody> {
  _CreateContactBodyState(this.contact);
  final ContactsModel contact;
  States _dropdownStates = statesList[24]; //SAO PAULO
  String _dropdownSchedule = schedule[1]; //Comercial

  final _form = GlobalKey<FormState>();
  ContactsModel _contactModel;
  bool _progressBarActive = false;
  String _fileImageUpload = '';
  String _fileAvatarUpload = '';

  initState() {
    super.initState();
    getServiceTypes();

    _contactModel = ContactsModel.fromContact(contact);
    if (_contactModel.address.state.isNotEmpty) {
      _dropdownStates = statesList
          .where((element) => element.state == _contactModel.address.state)
          .first;
    }
    if (_contactModel.scheduleType.first.isNotEmpty) {
      _dropdownSchedule = schedule
          .where((element) => element == _contactModel.scheduleType.first)
          .first;
    }

    if (_contactModel.lastModification == null)
      _contactModel.lastModification = DateTime.now();

    _contactModel.address.uf = _dropdownStates.uf;
    _contactModel.address.state = _dropdownStates.state;
    _contactModel.scheduleType.first = _dropdownSchedule;
  }

  List<MultiSelectItem> _items = List<MultiSelectItem>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: [
            Container(height: 30),
            Center(
              child: ImagePickerSource(
                image: _contactModel.imageAvatar,
                callback: callbackAvatar,
                isAvatar: true,
                imageQuality: 35,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _contactModel.name,
                onChanged: (value) {
                  _contactModel.name = value;
                },
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Nome",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.mail),
              title: new TextFormField(
                initialValue: _contactModel.email,
                onChanged: (value) {
                  _contactModel.email = value;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: new TextFormField(
                initialValue: _contactModel.description,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  _contactModel.description = value;
                },
                maxLines: 3,
                decoration: new InputDecoration(
                  hintText: "Descrição",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: MultiSelectDialogField(
                  initialValue: _contactModel.serviceType,
                  items: _items,
                  title: Text('Prestadores'),
                  buttonText: Text('Prestadores',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onConfirm: (results) => _contactModel.serviceType = results,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null),
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: new TextFormField(
                initialValue: _contactModel.site,
                onChanged: (value) {
                  _contactModel.site = value;
                },
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  hintText: "Site",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: TextFormField(
                maxLength: 17,
                initialValue: _contactModel.telNumbers['whatsapp'] == null
                    ? ''
                    : _contactModel.telNumbers['whatsapp'],
                onChanged: (value) {
                  _contactModel.telNumbers = {'whatsapp': value.trim()};
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "+55 (DDD) + 9 dígitos",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Funcionamento'),
                value: _dropdownSchedule,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  _contactModel.scheduleType.first = newValue;
                  setState(() {
                    _dropdownSchedule = newValue;
                  });
                },
                items: schedule.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            Text(
              'Horários',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
              textAlign: TextAlign.right,
            ),
            TimeTableAdmin(
              timeTable: _contactModel.timeTable,
              callback: callbackTimeTable,
            ),
            Divider(),
            Text(
              'Endereço',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
              textAlign: TextAlign.right,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _contactModel.address.strAvnName,
                onChanged: (value) {
                  _contactModel.address.strAvnName = value;
                },
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Rua/Avenida",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _contactModel.address.compliment,
                onChanged: (value) {
                  _contactModel.address.compliment = value;
                },
                decoration: InputDecoration(
                  hintText: "Complemento",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _contactModel.address.number,
                onChanged: (value) {
                  _contactModel.address.number = value;
                },
                decoration: InputDecoration(
                  hintText: "Número",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _contactModel.address.neighborhood,
                onChanged: (value) {
                  _contactModel.address.neighborhood = value;
                },
                decoration: InputDecoration(
                  hintText: "Bairro",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _contactModel.address.city,
                onChanged: (value) {
                  _contactModel.address.city = value;
                },
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "Cidade",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: DropdownButton<States>(
                isExpanded: true,
                hint: Text('Estado'),
                value: _dropdownStates,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (States newValue) {
                  _contactModel.address.uf = newValue.uf;
                  _contactModel.address.state = newValue.state;
                  setState(() {
                    _dropdownStates = newValue;
                  });
                },
                items: statesList.map<DropdownMenuItem<States>>((States value) {
                  return DropdownMenuItem<States>(
                    value: value,
                    child: Text(value.state),
                  );
                }).toList(),
              ),
            ),
            Divider(),
            Text(
              'Fotos',
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 25),
              textAlign: TextAlign.right,
            ),
            ListTile(
                title: ImagePickerSource(
              image: _contactModel.image,
              callback: callbackImage,
              imageQuality: 40,
            )),
            Container(height: 30),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                child: _progressBarActive == true
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Text('Salvar'),
                onPressed: saveContact,
              ),
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
  }

  callbackImage(file) {
    setState(() {
      _fileImageUpload = file;
    });
  }

  callbackAvatar(file) {
    setState(() {
      _fileAvatarUpload = file;
    });
  }

  callbackTimeTable(timeTable) {
    setState(() {
      _contactModel.timeTable = timeTable;
    });
  }

  Future<String> uploadFileImage(String refPath, String filePath) async {
    File file = File(filePath);

    await FirebaseStorage.instance.ref(refPath).putFile(file);
    return await FirebaseStorage.instance.ref(refPath).getDownloadURL();
  }

  void saveContact() async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });

      //referencia o doc e se tiver ID atualiza, se nao cria um ID novo
      DocumentReference contactDB = FirebaseFirestore.instance
          .collection('contatos')
          .doc(_contactModel.id);

      //Se houve alteração na imagem, faz um novo upload
      if (_fileImageUpload.isNotEmpty)
        _contactModel.image = await uploadFileImage(
            'uploads/' + contactDB.id + '/' + contactDB.id + '_background.png',
            _fileImageUpload);

      if (_fileAvatarUpload.isNotEmpty)
        _contactModel.imageAvatar = await uploadFileImage(
            'uploads/' + contactDB.id + '/' + contactDB.id + '_avatar.png',
            _fileAvatarUpload);

      if (_contactModel.createdAt == null)
        _contactModel.createdAt = DateTime.now();

      _contactModel.lastModification = DateTime.now();

      //tenta pegar geopoint com endereço providenciado
      var loc = await locationFromAddress(_contactModel.address.strAvnName +
          ' ' +
          _contactModel.address.number +
          ',' +
          _contactModel.address.neighborhood +
          ',' +
          _contactModel.address.city);

      _contactModel.address.coordinates =
          GeoPoint(loc.first.latitude, loc.first.longitude);

      contactDB
          .set({
            'nome': _contactModel.name,
            'email': _contactModel.email,
            'descricao': _contactModel.description,
            'servicos': _contactModel.serviceType,
            'site': _contactModel.site,
            'telefone1': _contactModel.telNumbers,
            'imagem': _contactModel.image,
            'avatar': _contactModel.imageAvatar,
            'horarios': _contactModel.timeTable,
            'funcionamento': _contactModel.scheduleType,
            'atualizacao': _contactModel.lastModification,
            'criacao': _contactModel.createdAt,
            'endereco': {
              'endereco': _contactModel.address.strAvnName,
              'complemento': _contactModel.address.compliment,
              'numero': _contactModel.address.number,
              'bairro': _contactModel.address.neighborhood,
              'cidade': _contactModel.address.city,
              'estado': _contactModel.address.state,
              'UF': _contactModel.address.uf,
              'coordenadas': _contactModel.address.coordinates,
            },
            'avaliacao': {
              'atendimento': _contactModel.rating.attendance,
              'geral': _contactModel.rating.general,
              'preco': _contactModel.rating.price,
              'qualidade': _contactModel.rating.quality,
              'quantidade': _contactModel.rating.number,
            }
          })
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _contactModel.id == null
                        ? Text('Contato adicionado com sucesso.')
                        : Text('Contato atualizado com sucesso.'),
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
          .then((value) => setState(() {
                _progressBarActive = false;
                _contactModel.id = contactDB.id;
              }))
          .catchError((error) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _contactModel.id == null
                        ? Text('Falha ao adicionar o contato.')
                        : Text('Falha ao atualizar o contato.'),
                    content: Text('Erro: ' + error),
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
          .then((value) => setState(() {
                _progressBarActive = false;
              }));
    }
  }

  Future<void> getServiceTypes() async {
    //Pega a tabela categorias somente da categoria selecionada
    List<String> prestadores = new List<String>();
    await FirebaseFirestore.instance
        .collection('prestadores')
        .orderBy('nome')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        return prestadores.add(element.data()['nome']);
      });
    });
    setState(() {
      _items = prestadores
          .map((prestador) => MultiSelectItem<String>(prestador, prestador))
          .toList();
    });
  }
}
