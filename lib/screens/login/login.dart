import 'package:AchaFacil/screens/login/components/login_body.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class Login extends StatelessWidget {
  static String routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        leading: BackButton(color: kTextColor),
      ),
      body: LoginBody(),
    );
  }
}
