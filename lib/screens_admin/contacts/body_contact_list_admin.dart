import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/confirmation_dialog.dart';
import 'package:AchaFacil/components/list_tile_admin.dart';
import 'create_contact.dart';

class BodyContactListAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('contatos');

    return Scaffold(
        appBar: AppBar(
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
                padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
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
            FirebaseFirestore.instance
                .collection('contatos')
                .doc(contact.id)
                .delete();
            Navigator.of(context).pop();
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
