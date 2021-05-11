import 'package:AchaFacil/apis/models/contacts_status.dart';
import 'package:AchaFacil/screens/admin_area/service_types/body_service_list_admin.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/menu/custom_drawer_admin.dart';
import 'categories/body_categories_list_admin.dart';
import 'contacts/body_contact_list_admin.dart';

class BodyAdminArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawerAdmin(),
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
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
      childAspectRatio: 1.1,
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
                fontSize: 25,
              ),
            )),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactListAdmin(
                      title: 'Lista de Contatos',
                      orderBy: 'nome',
                      showWithStatus: [Status.active],
                    )));
          },
        ),
        InkWell(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/check.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.darken))),
            padding: const EdgeInsets.all(8),
            child: Center(
                child: Text(
              "Contatos Pendentes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            )),
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BodyContactListAdmin(
                    title: 'Contatos Pendentes',
                    orderBy: 'criacao',
                    showWithStatus: [Status.pending])));
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
