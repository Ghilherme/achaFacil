import 'package:flutter/material.dart';
import 'package:listaUnica/apis/models/categories.dart';

import '../body_service_type.dart';

class BodyCategorieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: categories.length,
        itemBuilder: (context, i) {
          return _buildRow(context, categories[i], i);
        });
  }

  Widget _buildRow(BuildContext context, Categories category, int indice) {
    return Column(children: <Widget>[
      ListTile(
          title: Text(
            category.categorieName,
          ),
          subtitle: Text(category.subtitleCategorieName),
          leading: category.icons,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyServiceList(
                      serviceTypes: category.serviceType,
                      title: category.categorieName,
                    )));
          }),
      indice + 1 == categories.length ? Container() : Divider()
    ]);
  }
}
