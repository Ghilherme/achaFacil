import 'package:AchaFacil/components/custom_bottom_nav_bar.dart';
import 'package:AchaFacil/screens/service_list/components/body_service_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({Key key, this.category, this.title}) : super(key: key);
  static String routeName = "/service_list";
  final DocumentReference category;
  final String title;

/*    AppBar _buildAppBar(BuildContext context) {
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
  } */

  /* @override
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
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(title), leading: BackButton(color: kTextColor)),
      body: BodyServiceList(
        category: this.category,
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
