import 'package:AchaFacil/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class EndJourney extends StatelessWidget {
  const EndJourney({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Solicitação Finalizada'),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              })),
      body: EndJourneyBody(),
    );
  }
}

class EndJourneyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          margin: EdgeInsets.all(kDefaultPadding),
          elevation: 12,
          child: Image(
            image: Image.asset(
              'assets/images/sucess_message.png',
            ).image,
          ),
        ),
        Container(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            'Nós recebemos sua solicitação!\nEventualmente, pode haver a necessidade de entrarmos em contato para confirmação de dados.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTextLightColor,
            ),
          ),
        ),
        Container(
          height: 50,
        ),
        SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            child: Text(
              'CONTINUAR',
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        )
      ],
    );
  }
}
