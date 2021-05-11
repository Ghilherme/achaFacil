import 'package:AchaFacil/components/custom_bottom_nav_bar.dart';
import 'package:AchaFacil/screens/search/components/search_grid.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class Search extends StatelessWidget {
  static String routeName = "/search";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search"),
      ),
      body: SearchGrid(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.search),
    );
  }
}
