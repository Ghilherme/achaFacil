import 'package:AchaFacil/apis/gets.dart';
import 'package:AchaFacil/components/social_card.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/models/contacts.dart';
import 'package:AchaFacil/models/contacts_status.dart';
import 'package:AchaFacil/screens/login/login.dart';
import 'package:AchaFacil/screens/profile/profile.dart';
import 'package:AchaFacil/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up_form.dart';

class BodySignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text(
                  "É grátis!",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      textStyle: Theme.of(context).textTheme.headline4),
                ),
                Text(
                  "Cadastre-se e exponha seus serviços para onde preferir!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: kTextColor,
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () async {
                        usr = await _signInWithGoogle(context);
                        if (usr != null) signUpProcess(context, usr);
                      },
                    ),
                    SocialCard(
                      icon: "assets/icons/facebook-icon.svg",
                      press: () {},
                    )
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já possui uma conta?",
                      style: GoogleFonts.quicksand(
                          fontSize: getProportionateScreenWidth(16)),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, Login.routeName),
                      child: Text(
                        " Faça login!",
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            fontSize: getProportionateScreenWidth(18),
                            color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUpProcess(
      BuildContext context, UserCredential userCredential) async {
    //_getCurrentLogged(context, usr);

    _createNewUser(userCredential);

    //armazena em cache as informacoes do logado
    //final SharedPreferences prefs = await _prefs;
    //prefs.setBool('logado', true);
    //prefs.setString('logado_email', people.email);

    //mandar pra nova tela
    Navigator.pushNamed(context, Profile.routeName);
  }

  Future<UserCredential> _signInWithGoogle(BuildContext context) async {
    SnackBar snackBar;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser =
          await GoogleSignIn().signIn().catchError((onError) => print(onError));

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      String error = e.message;
      if (e.code == 'user-disabled') {
        error = 'Usuário desabilitado.';
      } else if (e.code == 'wrong-password') {
        error = 'Senha incorreta!';
      } else if (e.code == 'account-exists-with-different-credential')
        error = 'Conta já existente.';

      snackBar = SnackBar(content: Text(error));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  Future<bool> _getCurrentLogged(
      BuildContext context, UserCredential userCredential) async {
    SnackBar snackBar;
    try {
      ContactsModel contact = await Gets.getUserInfo(userCredential.user.email);
      if (contact.status == Status.disabled) {
        snackBar = SnackBar(content: Text('Usuário desabilitado.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        FirebaseAuth.instance.signOut();
        return false;
      }

      //coloca na constants para uso em memoria do app
      idContactLogged =
          FirebaseFirestore.instance.collection('pessoas').doc(contact.id);
      contactLogged = ContactsModel.fromContact(contact);

      return true;
    } on Exception catch (e) {
      snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  void _createNewUser(UserCredential userCredential) {
    print(userCredential);
    ContactsModel contact = ContactsModel.empty();
    contact.email = userCredential.user.email;
    contact.name = userCredential.user.displayName;
    print(contact);
  }
}
