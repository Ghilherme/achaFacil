import 'package:AchaFacil/models/categories.dart';
import 'package:AchaFacil/screens/service_list/service_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyCategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Pega a tabela categorias
    Query query =
        FirebaseFirestore.instance.collection('categorias').orderBy('titulo');

    //Cria Stream com essa query
    return StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }

          QuerySnapshot querySnapshot = stream.data;

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categorias",
                  style: GoogleFonts.quicksand(
                      color: Theme.of(context).primaryColor,
                      textStyle: Theme.of(context).textTheme.headline4),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: querySnapshot.size,
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.1,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return _buildRow(context, querySnapshot.docs[index],
                          index, querySnapshot.size);
                    }),
              ],
            ),
          );
        });
  }

  Widget _buildRow(
      BuildContext context, DocumentSnapshot snapshot, int indice, int size) {
    CategoriesModel categories = CategoriesModel.fromFirestore(snapshot);
    return InkWell(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: categories.banner == null || categories.banner == ''
                      ? AssetImage("assets/images/banner.png")
                      : Image.network(categories.banner).image,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.darken))),
          padding: const EdgeInsets.all(8),
          child: Center(
              child: Text(
            categories.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          )),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ServiceList(
                    category: snapshot.reference,
                    title: categories.title,
                  )));
        });
  }
}
