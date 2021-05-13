import 'package:AchaFacil/apis/models/service_types.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/screens/contact_list/contact_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class BodyServiceList extends StatefulWidget {
  BodyServiceList({Key key, @required this.category}) : super(key: key);
  final DocumentReference category;

  @override
  _BodyServiceListState createState() => _BodyServiceListState();
}

class _BodyServiceListState extends State<BodyServiceList> {
  SearchBar _searchBar;
  String _searchName = '';

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance
        .collection('prestadores')
        .where(
          'categoria',
          isEqualTo: widget.category,
        )
        .where('nome', isGreaterThanOrEqualTo: _searchName)
        .where('nome', isLessThan: _searchName + 'z')
        .orderBy('nome');

    return SafeArea(
      child: StreamBuilder(
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

          return ListView.separated(
              padding: EdgeInsets.all(kDefaultPaddingListView),
              itemCount: querySnapshot.size,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, i) {
                return _buildRow(
                    context, querySnapshot.docs[i], querySnapshot.size);
              });
        },
      ),
    );
  }

  Widget _buildRow(BuildContext context, DocumentSnapshot snapshot, int size) {
    ServiceTypesModel services = ServiceTypesModel.fromFirestore(snapshot);

    return Column(children: <Widget>[
      ListTile(
          title: Text(services.name),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 15,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContactList(
                      title: services.name,
                      serviceType: services.category,
                      menuState: MenuState.home,
                    )));
          }),
    ]);
  }
}
