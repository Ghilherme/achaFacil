import 'package:flutter/material.dart';
import 'package:AchaFacil/menu/custom_drawer_admin.dart';
import 'package:AchaFacil/screens_admin/categories/body_categories_list_admin.dart';
import 'package:AchaFacil/screens_admin/contacts/body_contact_list_admin.dart';
import 'package:AchaFacil/screens_admin/service_types/body_service_list_admin.dart';

class BodyAdminArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawerAdmin(),
        appBar: AppBar(
          title: Text('Área Administrativa'),
          elevation: 0,
        ),
        body: Entities());
  }
}

class Entities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        InkWell(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/contacts.jpeg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken))),
            padding: const EdgeInsets.all(8),
            child: Center(
                child: Text(
              "Contatos",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactListAdmin()));
          },
        ),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/providers.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken))),
            padding: const EdgeInsets.all(8),
            child: Center(
                child: Text(
              "Prestadores",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyServiceListAdmin()));
          },
        ),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/categories.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken))),
            padding: const EdgeInsets.all(8),
            child: Center(
                child: Text(
              "Categorias",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            )),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyCategoriesListAdmin()));
          },
        ),
      ],
    );
  }
}
