import 'package:AchaFacil/components/default_button.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/screens/register/register_journey.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String confirm_password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              initialValue: '',
              onChanged: (value) {
                '';
              },
              keyboardType: TextInputType.emailAddress,
              maxLines: 1,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Email',
                  hintText: 'Ex: achafacil@gmail.com'),
              validator: (value) {
                return value.isEmpty
                    ? kObligatoryFieldError
                    : RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)
                        ? null
                        : kInvalidEmailError;
              }),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              password = value;
            },
            validator: (value) {
              if (value.isEmpty)
                return kObligatoryFieldError;
              else if (value.length < 8) return kShortPassError;

              return null;
            },
            decoration: InputDecoration(
              labelText: "Senha",
              hintText: "Mínimo 8 caracteres",
              suffixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => confirm_password = newValue,
            onChanged: (value) {
              confirm_password = value;
            },
            validator: (value) {
              if (value.isEmpty)
                return kObligatoryFieldError;
              else if ((password != value)) return kMatchPassError;

              return null;
            },
            decoration: InputDecoration(
              labelText: "Confirmar senha",
              suffixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Continuar",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                Navigator.pushNamed(context, RegisterJourney.routeName);
              }
            },
          ),
        ],
      ),
    );
  }
}
