import 'package:AchaFacil/components/social_card.dart';
import 'package:AchaFacil/constants.dart';
import 'package:AchaFacil/screens/login/login.dart';
import 'package:AchaFacil/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      press: () {},
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
}
