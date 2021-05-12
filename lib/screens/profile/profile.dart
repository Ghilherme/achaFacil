import 'package:AchaFacil/components/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';
import 'components/body.dart';

class Profile extends StatelessWidget {
  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
