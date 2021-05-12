import 'package:AchaFacil/apis/models/service_types.dart';
import 'package:AchaFacil/components/custom_bottom_nav_bar.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/screens/contact_list/contact_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class BodyServiceList extends StatefulWidget {
  BodyServiceList({Key key, @required this.category, this.title})
      : super(key: key);
  final DocumentReference category;
  final String title;

  @override
  _BodyServiceListState createState() => _BodyServiceListState();
}

class _BodyServiceListState extends State<BodyServiceList> {
  SearchBar _searchBar;
  String _searchName = '';

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        title: Text(widget.title),
        elevation: 0,
        actions: <Widget>[
          _searchBar.getSearchAction(context),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    _searchBar = new SearchBar(
        inBar: false,
        hintText: 'Pesquise',
        setState: setState,
        onSubmitted: print,
        onChanged: _onChanged,
        showClearButton: false,
        onClosed: _onClosed,
        buildDefaultAppBar: _buildAppBar);
  }

  void _onChanged(String value) {
    String finalSearch = value.isNotEmpty
        ? value.substring(0, 1).toUpperCase() + value.substring(1)
        : value;
    setState(() => _searchName = finalSearch);
  }

  void _onClosed() {
    setState(() => _searchName = '');
  }

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

    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        body: SafeArea(
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
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemBuilder: (context, i) {
                    return _buildRow(
                        context, querySnapshot.docs[i], querySnapshot.size);
                  });
            },
          ),
        ));
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
