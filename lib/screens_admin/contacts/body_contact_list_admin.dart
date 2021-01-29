import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/confirmation_dialog.dart';
import 'package:AchaFacil/components/list_tile_admin.dart';
import '../../constants.dart';
import 'create_contact.dart';

class BodyContactListAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('contatos').orderBy('nome');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('Lista de Contatos'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateContact(
                              contact: ContactsModel.empty(),
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
                itemCount: querySnapshot.size,
                itemBuilder: (context, i) {
                  return _buildRow(
                      context, querySnapshot.docs[i], i, querySnapshot.size);
                });
          },
        ));
  }

  Widget _buildRow(BuildContext context, QueryDocumentSnapshot snapshot,
      int indice, int size) {
    ContactsModel contact = ContactsModel.fromFirestore(snapshot);
    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Nome: ' +
              contact.name +
              '\nCidade: ' +
              contact.address.city +
              '\nEstado: ' +
              contact.address.uf,
          okFunction: () {
            if (contact.image.isNotEmpty)
              FirebaseStorage.instance.refFromURL(contact.image).delete();

            if (contact.imageAvatar.isNotEmpty)
              FirebaseStorage.instance.refFromURL(contact.imageAvatar).delete();

            FirebaseFirestore.instance
                .collection('contatos')
                .doc(contact.id)
                .delete();
          },
          title: 'Deseja excluir o contato?',
        ),
        title: contact.name,
        subtitle: contact.address.city + ' ' + contact.address.uf,
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateContact(contact: contact)));
        },
      ),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
