import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/service_types.dart';
import 'package:listaUnica/components/confirmation_dialog.dart';
import 'package:listaUnica/components/list_tile_admin.dart';
import 'package:listaUnica/screens_admin/service_types/create_service_type.dart';

class BodyServiceListAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('prestadores').orderBy('nome');

    return Scaffold(
        appBar: AppBar(
            title: Text('Lista de Serviços'),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateServiceType(
                              serviceTypes: ServiceTypesModel.empty(),
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
    ServiceTypesModel serviceType = ServiceTypesModel.fromFirestore(snapshot);
    return Column(children: <Widget>[
      ListTileAdmin(
        confirmationDialog: ConfirmationDialog(
          content: 'Nome: ' +
              serviceType.name +
              '\nCategoria: ' +
              serviceType.categoryTitle,
          okFunction: () {
            FirebaseFirestore.instance
                .collection('prestadores')
                .doc(serviceType.id)
                .delete();
            Navigator.of(context).pop();
          },
          title: 'Deseja excluir o prestador?',
        ),
        title: serviceType.name,
        subtitle: serviceType.categoryTitle,
        editFunction: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CreateServiceType(serviceTypes: serviceType)));
        },
      ),
      indice + 1 == size ? Container() : Divider()
    ]);
  }
}
