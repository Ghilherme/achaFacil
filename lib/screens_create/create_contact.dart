import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/contacts.dart';
import 'package:listaUnica/apis/models/states.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateContact extends StatelessWidget {
  final Contacts contact;

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
  final Contacts contact;

  @override
  _CreateContactBodyState createState() =>
      _CreateContactBodyState(this.contact);
}

class _CreateContactBodyState extends State<CreateContactBody> {
  _CreateContactBodyState(this.contact);
  final Contacts contact;
  States _dropdownValue = states[24]; //SAO PAULO
  final _form = GlobalKey<FormState>();
  Contacts _contactModel;

  initState() {
    super.initState();
    getProviders();

    _contactModel = Contacts.fromContact(contact);
    if (_contactModel.address.state.isNotEmpty) {
      _dropdownValue = states
          .where((element) => element.state == _contactModel.address.state)
          .first;
    }
  }

  List<MultiSelectItem> _items = List<MultiSelectItem>();

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
                initialValue: _contactModel.name,
                onChanged: (value) {
                  _contactModel.name = value;
                },
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
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Site",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: TextFormField(
                initialValue: _contactModel.telNumbers['whatsapp'],
                onChanged: (value) {
                  _contactModel.telNumbers = {'whatsapp': value};
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Telefone",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
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
                value: _dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (States newValue) {
                  _contactModel.address.uf = newValue.uf;
                  _contactModel.address.state = newValue.state;
                  setState(() {
                    _dropdownValue = newValue;
                  });
                },
                items: states.map<DropdownMenuItem<States>>((States value) {
                  return DropdownMenuItem<States>(
                    value: value,
                    child: Text(value.state),
                  );
                }).toList(),
              ),
            ),
            Container(height: 30),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: Text('Cadastrar'),
                onPressed: addContact,
              ),
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
  }

  void addContact() {
    if (_form.currentState.validate()) {
      CollectionReference contactDB =
          FirebaseFirestore.instance.collection('contatos');
      contactDB
          .add({
            'nome': _contactModel.name,
            'email': _contactModel.email,
            'descricao': _contactModel.description,
            'servicos': _contactModel.serviceType,
            'site': _contactModel.site,
            'telefone1': _contactModel.telNumbers,
            'endereco': {
              'endereco': _contactModel.address.strAvnName,
              'complemento': _contactModel.address.compliment,
              'numero': _contactModel.address.number,
              'bairro': _contactModel.address.neighborhood,
              'cidade': _contactModel.address.city,
              'estado': _contactModel.address.state,
              'UF': _contactModel.address.uf,
            },
          })
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Contato adicionado com sucesso.'),
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
          .catchError((error) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Falha ao adicionar usuário.'),
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
              ));
    }
  }

  Future<void> getProviders() async {
    //Pega a tabela categorias somente da categoria selecionada
    List<String> testes = new List<String>();
    await FirebaseFirestore.instance
        .collection('prestadores')
        .orderBy('nome')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        return testes.add(element.data()['nome']);
      });
    });
    setState(() {
      _items = testes
          .map((prestador) => MultiSelectItem<String>(prestador, prestador))
          .toList();
    });
  }
}
