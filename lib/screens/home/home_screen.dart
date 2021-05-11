import 'package:AchaFacil/components/custom_bottom_nav_bar.dart';
import 'package:AchaFacil/size_config.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
