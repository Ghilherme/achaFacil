import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/categories.dart';
import 'package:listaUnica/body_contact.dart';

import 'apis/models/contacts.dart';
import 'apis/models/service_type.dart';

class BodyServiceList extends StatelessWidget {
  BodyServiceList({Key key, @required this.serviceTypes, @required this.title})
      : super(key: key);
  final List<ServiceType> serviceTypes;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(title),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: serviceTypes.length,
          itemBuilder: (context, i) {
            return _buildRow(context, serviceTypes[i], i);
          }),
    );
  }

  Widget _buildRow(BuildContext context, ServiceType service, int indice) {
    return Column(children: <Widget>[
      ListTile(
          title: Text(
            service.serviceName,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactList(
                    title: service.serviceName,
                    contacts: contacts
                        .where((x) => x.serviceType.contains(service))
                        .toList())));
          }),
      indice + 1 == categories.length ? Container() : Divider()
    ]);
  }
}
