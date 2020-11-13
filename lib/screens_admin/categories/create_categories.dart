import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/categories.dart';

class CreateCategories extends StatelessWidget {
  final CategoriesModel categories;

  const CreateCategories({Key key, this.categories}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Criar Categoria'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: CreateCategoriesBody(categories),
    );
  }
}

class CreateCategoriesBody extends StatefulWidget {
  CreateCategoriesBody(this.categories);
  final CategoriesModel categories;

  @override
  _CreateCategoriesBodyState createState() =>
      _CreateCategoriesBodyState(this.categories);
}

class _CreateCategoriesBodyState extends State<CreateCategoriesBody> {
  _CreateCategoriesBodyState(this.categories);
  final CategoriesModel categories;

  final _form = GlobalKey<FormState>();
  CategoriesModel _categoriesModel;

  initState() {
    super.initState();

    _categoriesModel = CategoriesModel.fromCategories(categories);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.title),
              title: TextFormField(
                initialValue: _categoriesModel.title,
                onChanged: (value) {
                  _categoriesModel.title = value;
                },
                decoration: InputDecoration(
                  hintText: "Título",
                ),
                validator: (value) =>
                    value.isEmpty ? 'Campo obrigatório' : null,
              ),
            ),
            ListTile(
              leading: Icon(Icons.subtitles),
              title: new TextFormField(
                initialValue: _categoriesModel.subtitle,
                onChanged: (value) {
                  _categoriesModel.subtitle = value;
                },
                decoration: InputDecoration(
                  hintText: "Subtítulo",
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.text_fields),
              title: new TextFormField(
                initialValue: _categoriesModel.icons,
                onChanged: (value) {
                  _categoriesModel.icons = value;
                },
                decoration: InputDecoration(
                  hintText: "Ícone",
                ),
              ),
            ),
            Container(height: 30),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                child: Text('Salvar'),
                onPressed: saveCategories,
              ),
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
  }

  void saveCategories() {
    if (_form.currentState.validate()) {
      DocumentReference contactDB = FirebaseFirestore.instance
          .collection('categorias')
          .doc(_categoriesModel.id);

      contactDB
          .set({
            'titulo': _categoriesModel.title,
            'subtitulo': _categoriesModel.subtitle,
            'icone': _categoriesModel.icons,
          })
          .then((value) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: _categoriesModel.id == null
                        ? Text('Categoria adicionada com sucesso.')
                        : Text('Categoria atualizada com sucesso.'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
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
                    title: _categoriesModel.id == null
                        ? Text('Falha ao adicionar o categoria.')
                        : Text('Falha ao atualizar o categoria.'),
                    content: Text('Erro: ' + error),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
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
}
