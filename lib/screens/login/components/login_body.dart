import 'package:AchaFacil/components/social_card.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/screens/login/components/login_form.dart';
import 'package:AchaFacil/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Text(
                        "Bem-vindo de volta!",
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            textStyle: Theme.of(context).textTheme.headline5),
                      ),
                      Text(
                        "Faça o login com email e senha \nou entre com suas redes sociais",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset("assets/icons/logo.png"),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      LoginForm(),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialCard(
                            icon: "assets/icons/google-icon.svg",
                            press: () {},
                          ),
                          SocialCard(
                            icon: "assets/icons/facebook-icon.svg",
                            press: () {},
                          )
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Text(
                        'Ao continuar, você concorda com \nnossos Termos e Condições',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ))));
  }
}
