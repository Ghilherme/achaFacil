import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../create_contact.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
        ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            _validateLogin(_formKey, login, pass, context);
          },
        ),
      ]),
    );
  }

  void _validateLogin(GlobalKey<FormState> _formKey, String login, String pass,
      BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (login == 'guilherme' && pass == '123') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateContact(),
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
