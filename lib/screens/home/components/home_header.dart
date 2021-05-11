import 'package:AchaFacil/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: "Bem-vindo ao",
              style: GoogleFonts.quicksand(
                  color: kPrimaryColor,
                  textStyle: Theme.of(context).textTheme.headline6),
            ),
            TextSpan(text: "\n"),
            TextSpan(
              text: "Acha Fácil",
              style: GoogleFonts.quicksand(
                  color: kPrimaryColor,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
            ),
          ],
        ),
      ),
    );
  }
}
