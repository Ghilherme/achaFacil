import 'package:AchaFacil/screens/sign_up/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroSliderScreen extends StatefulWidget {
  @override
  _IntroSliderScreenState createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "GRÁTIS",
        description:
            "Quer divulgar seus serviços? \nCadastre-se no app que mais cresce no Brasil!",
        centerWidget: SvgPicture.asset(
          "assets/images/undraw_1.svg",
          height: 250,
          width: 300,
        ),
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "DIVULGUE",
        description:
            "Alcance milhares de pessoas que querem facilidade em achar qualquer prestação de serviços...",
        centerWidget: SvgPicture.asset(
          "assets/images/undraw_2.svg",
          height: 250,
          width: 300,
        ),
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "SEM ENROLAÇÂO",
        description:
            "Seja contatado facilmente sem cadastros ou burocracias...",
        centerWidget: SvgPicture.asset(
          "assets/images/undraw_3.svg",
          height: 250,
          width: 300,
        ),
        backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      nameDoneBtn: 'OK',
      nameNextBtn: 'PRÓXIMO',
      nameSkipBtn: 'PULAR',
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
