import 'package:AchaFacil/apis/models/contacts_status.dart';
import 'package:AchaFacil/components/list_view_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/contacts.dart';
import 'package:AchaFacil/components/confirmation_dialog.dart';
import 'package:AchaFacil/components/list_tile_admin.dart';
import '../../../constants.dart';
import 'create_contact.dart';

class BodyContactListAdmin extends StatelessWidget {
  final String orderBy, title;
  final List<String> showWithStatus;

  const BodyContactListAdmin(
      {Key key,
      @required this.orderBy,
      @required this.showWithStatus,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('contatos')
        .where('status', whereIn: showWithStatus)
        .orderBy(orderBy);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text(title),
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
        title: size.toString() + ' Contatos no total',
      );

    index -= 1;
    ContactsModel contact = ContactsModel.fromFirestore(snapshot[index]);

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
                .update({'status': Status.disabled});
          },
          title: 'Deseja desabilitar o contato?',
        ),
        title: contact.name,
        subtitle: contact.serviceType.join(', ') +
            '\nCriado em: ' +
            "${contact.createdAt.day.toString().padLeft(2, '0')}-${contact.createdAt.month.toString().padLeft(2, '0')}-${contact.createdAt.year.toString()} ${contact.createdAt.hour.toString().padLeft(2, '0')}:${contact.createdAt.minute.toString().padLeft(2, '0')}" +
            '\n' +
            contact.address.city +
            ' - ' +
            contact.address.uf,
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateContact(contact: contact)));
        },
      ),
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
