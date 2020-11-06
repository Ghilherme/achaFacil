import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/contacts.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateContact extends StatelessWidget {
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
      body: CreateContactBody(),
    );
  }
}

class CreateContactBody extends StatefulWidget {
  @override
  _CreateContactBodyState createState() => _CreateContactBodyState();
}

class _CreateContactBodyState extends State<CreateContactBody> {
  String dropdownValue = 'São Paulo';
  final _form = GlobalKey<FormState>();
  Contacts contactModel = new Contacts(
      address: new Address('', '', '', '', '', '', '', '', ''),
      email: null,
      telNumbers: null,
      description: null,
      name: null,
      serviceType: new List<dynamic>());

  initState() {
    super.initState();
    getProviders();
  }

  List<MultiSelectItem> _items;

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
                onChanged: (value) {
                  contactModel.name = value;
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
                onChanged: (value) {
                  contactModel.email = value;
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
                onChanged: (value) {
                  contactModel.description = value;
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
                  items: _items,
                  title: Text('Prestadores'),
                  buttonText: Text('Prestadores',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  onConfirm: (results) => contactModel.serviceType = results,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Campo obrigatório'
                      : null),
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: new TextFormField(
                onChanged: (value) {
                  contactModel.site = value;
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
                onChanged: (value) {
                  contactModel.telNumbers = {'whatsapp': value};
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
                onChanged: (value) {
                  contactModel.address.strAvnName = value;
                },
                decoration: InputDecoration(
                  hintText: "Rua/Avenida",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                onChanged: (value) {
                  contactModel.address.compliment = value;
                },
                decoration: InputDecoration(
                  hintText: "Complemento",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                onChanged: (value) {
                  contactModel.address.number = value;
                },
                decoration: InputDecoration(
                  hintText: "Número",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                onChanged: (value) {
                  contactModel.address.neighborhood = value;
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
                onChanged: (value) {
                  contactModel.address.city = value;
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
              title: DropdownButton<String>(
                isExpanded: true,
                hint: Text('Estado'),
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                onChanged: (String newValue) {
                  contactModel.address.uf = newValue;
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  'São Paulo',
                  'Rio de Janeiro',
                  'Santa Catarina',
                  'Minas Gerais'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(height: 30),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: Text('Cadastrar'),
                onPressed: () {
                  if (_form.currentState.validate()) {
                    CollectionReference contactDB =
                        FirebaseFirestore.instance.collection('contatos');
                    contactDB
                        .add({
                          'nome': contactModel.name,
                          'email': contactModel.email,
                          'descricao': contactModel.description,
                          'servicos': contactModel.serviceType,
                          'site': contactModel.site,
                          'telefone1': contactModel.telNumbers,
                          'endereco': {
                            'endereco': contactModel.address.strAvnName,
                            'complemento': contactModel.address.compliment,
                            'numero': contactModel.address.number,
                            'bairro': contactModel.address.neighborhood,
                            'cidade': contactModel.address.city,
                            'UF': contactModel.address.uf,
                          },
                        })
                        .then((value) => print("User Added"))
                        .catchError(
                            (error) => print("Failed to add user: $error"));
                  }
                },
              ),
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
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
