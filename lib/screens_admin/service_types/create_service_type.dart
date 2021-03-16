import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/service_types.dart';

class CreateServiceType extends StatelessWidget {
  final ServiceTypesModel serviceTypes;

  const CreateServiceType({Key key, this.serviceTypes}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text('Criar Prestadores'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: CreateServiceTypesBody(serviceTypes),
    );
  }
}

class CreateServiceTypesBody extends StatefulWidget {
  CreateServiceTypesBody(this.serviceTypes);
  final ServiceTypesModel serviceTypes;

  @override
  _CreateServiceTypesBodyState createState() =>
      _CreateServiceTypesBodyState(this.serviceTypes);
}

class _CreateServiceTypesBodyState extends State<CreateServiceTypesBody> {
  _CreateServiceTypesBodyState(this.serviceTypes);
  final ServiceTypesModel serviceTypes;

  final _form = GlobalKey<FormState>();

  ServiceTypesModel _serviceModel;
  bool _progressBarActive = false;

  var setDefaultCategory = true;
  var category;
  initState() {
    super.initState();
    _serviceModel = ServiceTypesModel.fromServiceType(serviceTypes);

    if (_serviceModel.categoryTitle.isNotEmpty) {
      category = _serviceModel.categoryTitle;
      setDefaultCategory = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                initialValue: _serviceModel.name,
                onChanged: (value) {
                  _serviceModel.name = value;
                },
                decoration: InputDecoration(
                  hintText: "Nome",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
                leading: Icon(Icons.person),
                title: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categorias')
                        .orderBy('titulo')
                        .snapshots(),
                    builder: (context, snapshot) {
                      //Trata Load
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      //Trata Erro
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }

                      if (setDefaultCategory) {
                        category = snapshot.data.docs[0].get('titulo');
                        _serviceModel.categoryTitle = category;
                        _serviceModel.category =
                            snapshot.data.docs[0].reference;
                      }

                      return DropdownButton(
                        isExpanded: true,
                        hint: Text('Categoria'),
                        value: category,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        onChanged: (newValue) {
                          setState(() {
                            _serviceModel.categoryTitle = newValue;
                            _serviceModel.category = snapshot.data.docs
                                .where((element) {
                                  return element.get('titulo') == newValue;
                                })
                                .first
                                .reference;
                            category = newValue;
                            setDefaultCategory = false;
                          });
                        },
                        items: snapshot.data.docs.map((value) {
                          return DropdownMenuItem(
                            value: value.get('titulo'),
                            child: Text('${value.get('titulo')}'),
                          );
                        }).toList(),
                      );
                    })),
            Container(height: 30),
            SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                child: _progressBarActive == true
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Text('Salvar'),
                onPressed: addServiceType,
              ),
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
  }

  void addServiceType() async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });
      //referencia documento que está sendo atualizado / se não existir cria um novo
      DocumentReference contactDB = FirebaseFirestore.instance
          .collection('prestadores')
          .doc(_serviceModel.id);

      FirebaseFirestore.instance
          .runTransaction((transaction) async {
            //Referencia coleção
            QuerySnapshot contatos = await FirebaseFirestore.instance
                .collection('contatos')
                .where('servicos', arrayContains: serviceTypes.name)
                .get();

            //atualiza todo contato
            contatos.docs.forEach((contato) {
              transaction.update(contato.reference, {
                'servicos': FieldValue.arrayRemove([serviceTypes.name])
              });
              transaction.update(contato.reference, {
                'servicos': FieldValue.arrayUnion([_serviceModel.name])
              });
            });

            //atualiza prestadores
            transaction.set(contactDB, {
              'nome': _serviceModel.name,
              'titulo_categoria': _serviceModel.categoryTitle,
              'categoria': _serviceModel.category,
            });
          })
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _serviceModel.id == null
                        ? Text('Serviço adicionado com sucesso.')
                        : Text('Serviço atualizado com sucesso.'),
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
              }))
          .catchError((error) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _serviceModel.id == null
                        ? Text('Falha ao adicionar o serviço.')
                        : Text('Falha ao atualizar o serviço.'),
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
}
