import 'package:AchaFacil/constants.dart';
import 'package:flutter/material.dart';

import 'components/body_sign_up.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        leading: BackButton(color: kTextColor),
      ),
      body: Builder(
        builder: (context) => BodySignUp(),
      ),
    );
  }
}
