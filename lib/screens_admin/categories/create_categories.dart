import 'dart:io';

import 'package:AchaFacil/components/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  bool _progressBarActive = false;
  String _fileBannerUpload = '';

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
            Container(height: 30),
            ListTile(
                leading: Text('Banner'),
                title: ImagePickerSource(
                  image: categories.banner,
                  callback: callbackImage,
                  imageQuality: 40,
                )),
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
                  onPressed: saveCategories),
            ),
            Container(height: 30),
          ],
        ),
      ),
    );
  }

  callbackImage(file) {
    setState(() {
      _fileBannerUpload = file;
    });
  }

  Future<String> uploadFileImage(String refPath, String filePath) async {
    File file = File(filePath);

    await FirebaseStorage.instance.ref(refPath).putFile(file);
    return await FirebaseStorage.instance.ref(refPath).getDownloadURL();
  }

  void saveCategories() async {
    if (_form.currentState.validate()) {
      setState(() {
        _progressBarActive = true;
      });
      //referencia documento que está sendo atualizado / se não existir cria um novo
      DocumentReference contactDB = FirebaseFirestore.instance
          .collection('categorias')
          .doc(_categoriesModel.id);

      //Se houve alteração na imagem, faz um novo upload
      if (_fileBannerUpload.isNotEmpty)
        _categoriesModel.banner = await uploadFileImage(
            'categorias/banners/' + _categoriesModel.title + '_background.png',
            _fileBannerUpload);

      FirebaseFirestore.instance
          .runTransaction((transaction) async {
            //Referencia coleção
            QuerySnapshot prestadores = await FirebaseFirestore.instance
                .collection('prestadores')
                .where('titulo_categoria', isEqualTo: categories.title)
                .get();

            //atualiza todo prestador
            prestadores.docs.forEach((prestador) {
              transaction.update(prestador.reference,
                  {'titulo_categoria': _categoriesModel.title});
            });

            //atualiza categoria
            transaction.set(contactDB, {
              'titulo': _categoriesModel.title,
              'subtitulo': _categoriesModel.subtitle,
              'icone': _categoriesModel.icons,
              'banner': _categoriesModel.banner
            });
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
          .then((value) => setState(() {
                _progressBarActive = false;
              }))
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
              ))
          .then((value) => setState(() {
                _progressBarActive = false;
              }));
    }
  }
}
