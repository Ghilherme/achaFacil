import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AchaFacil/screens_admin/body_admin_area.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    String pass = '';
    String login = '';
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        TextFormField(
          onChanged: (text) {
            login = text;
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "E-mail",
            labelStyle: TextStyle(
              color: kTextLightColor,
              fontSize: 15,
            ),
          ),
          style: TextStyle(fontSize: 18),
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          onChanged: (text) {
            pass = text;
          },
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Senha",
            labelStyle: TextStyle(
              color: kTextLightColor,
              fontSize: 15,
            ),
          ),
          style: TextStyle(fontSize: 18),
          validator: (value) => value.isEmpty ? 'Campo obrigatório' : null,
        ),
        SizedBox(
          height: 40,
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: Text(
              'Login',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _validateLogin(_formKey, login, pass, context);
            },
          ),
        ),
      ]),
    );
  }

  void _validateLogin(GlobalKey<FormState> _formKey, String login, String pass,
      BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (login == 'admin' && pass == 'FACIL2021') {
        final SharedPreferences prefs = await _prefs;
        prefs.setBool('logado', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BodyAdminArea(),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login inválido.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
