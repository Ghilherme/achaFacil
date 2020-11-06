import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateContact extends StatelessWidget {
  // This widget is the root of your application.
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
  final _form = GlobalKey<FormFieldState>();

  static List<String> prestadors = [
    'Marceneiros',
    'Eletricistas',
    'Encanadores'
  ];
  final _items = prestadors
      .map((prestador) => MultiSelectItem<String>(prestador, prestador))
      .toList();
  List<String> _selectedAnimals = [];

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
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: new TextFormField(
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
                  onConfirm: (results) => _selectedAnimals = results,
                  validator: (values) {
                    if (values == null || values.isEmpty) return "Obrigatório";
                  }),
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: new TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Site",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: TextFormField(
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
                decoration: InputDecoration(
                  hintText: "Rua/Avenida",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                decoration: InputDecoration(
                  hintText: "Complemento",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
                decoration: InputDecoration(
                  hintText: "Número",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: TextFormField(
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
            ElevatedButton(
              child: Text('Cadastrar'),
              onPressed: () {},
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
  }
}
