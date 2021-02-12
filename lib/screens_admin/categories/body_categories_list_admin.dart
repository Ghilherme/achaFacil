import 'package:AchaFacil/components/list_view_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/categories.dart';
import 'package:AchaFacil/components/confirmation_dialog.dart';
import 'package:AchaFacil/components/list_tile_admin.dart';
import 'package:AchaFacil/screens_admin/categories/create_categories.dart';

import '../../constants.dart';

class BodyCategoriesListAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('categorias').orderBy('titulo');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('Lista de Categorias'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateCategories(
                              categories: CategoriesModel.empty(),
                            )));
                  })
            ],
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: StreamBuilder(
          stream: query.snapshots(),
          builder: (context, stream) {
            //Trata Load
            if (stream.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            //Trata Erro
            if (stream.hasError) {
              return Center(child: Text(stream.error.toString()));
            }

            QuerySnapshot querySnapshot = stream.data;

            return ListView.builder(
                padding: EdgeInsets.only(
                    top: kDefaultPaddingListView,
                    bottom: kDefaultPaddingListView,
                    left: kDefaultPaddingListView),
                itemCount:
                    querySnapshot.size == null ? 1 : querySnapshot.size + 1,
                itemBuilder: (context, i) {
                  return _buildRow(
                      context, querySnapshot.docs, i, querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(BuildContext context, List<QueryDocumentSnapshot> snapshot,
      int index, int size) {
    if (index == 0)
      return ListViewHeader(
        title: size.toString() + ' Categorias no total',
      );
    index -= 1;

    CategoriesModel categories = CategoriesModel.fromFirestore(snapshot[index]);
    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Título: ' +
              categories.title +
              '\nSubtítulo: ' +
              categories.subtitle,
          okFunction: () {
            if (categories.banner.isNotEmpty)
              FirebaseStorage.instance.refFromURL(categories.banner).delete();
            FirebaseFirestore.instance
                .collection('categorias')
                .doc(categories.id)
                .delete();
            Navigator.of(context).pop();
          },
          title: 'Deseja excluir a categoria?',
        ),
        title: categories.title,
        subtitle: categories.subtitle,
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateCategories(categories: categories)));
        },
      ),
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
