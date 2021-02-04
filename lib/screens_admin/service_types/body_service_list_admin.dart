import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/apis/models/service_types.dart';
import 'package:AchaFacil/components/confirmation_dialog.dart';
import 'package:AchaFacil/components/list_tile_admin.dart';
import 'package:AchaFacil/screens_admin/service_types/create_service_type.dart';

import '../../constants.dart';

class BodyServiceListAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Query query =
        FirebaseFirestore.instance.collection('prestadores').orderBy('nome');

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: Text('Lista de Prestadores'),
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
      return new Padding(
        padding: EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2,
          horizontal: kDefaultPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              size.toString() + ' Prestadores no total',
              style: Theme.of(context).textTheme.headline5,
            ),
            Container(height: 30)
          ],
        ),
      );

    index -= 1;
    ServiceTypesModel serviceType =
        ServiceTypesModel.fromFirestore(snapshot[index]);

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
      index + 1 == size ? Container() : Divider()
    ]);
  }
}
