import 'package:AchaFacil/components/default_button.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/screens/register/register_journey.dart';
import 'package:AchaFacil/screens/sign_up/components/body_sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirm_password;
  bool _progressBarActive = false;

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
            onSaved: (newValue) => _password = newValue,
            onChanged: (value) {
              _password = value;
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
            onSaved: (newValue) => _confirm_password = newValue,
            onChanged: (value) {
              _confirm_password = value;
            },
            validator: (value) {
              if (value.isEmpty)
                return kObligatoryFieldError;
              else if ((_password != value)) return kMatchPassError;

              return null;
            },
            decoration: InputDecoration(
              labelText: "Confirmar senha",
              suffixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter buttonState) {
            return _progressBarActive
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : DefaultButton(
                    text: "Continuar",
                    press: () async {
                      if (_formKey.currentState.validate()) {
                        buttonState(() {
                          _progressBarActive = true;
                        });
                        _formKey.currentState.save();

                        usr =
                            await _signUpWithEmail(context, _email, _password);

                        if (usr != null)
                          BodySignUp().signUpProcess(context, usr);
                        buttonState(() {
                          _progressBarActive = false;
                        });
                        Navigator.pushNamed(context, RegisterJourney.routeName);
                      }
                    },
                  );
          }),
        ],
      ),
    );
  }

  Future<UserCredential> _signUpWithEmail(
      BuildContext context, String email, String password) async {
    SnackBar snackBar;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      String error = e.message;
      if (e.code == 'weak-password') {
        error = 'Senha fraca. Necessário mínimo de 6 caracteres.';
      } else if (e.code == 'email-already-in-use') {
        error = 'Usuário já cadastrado para esse email!';
      }
      snackBar = SnackBar(content: Text(error));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }
}
