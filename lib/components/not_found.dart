import 'package:AchaFacil/screens_register/register_journey.dart';
import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: Image.asset(
            'assets/images/not_found.png',
          ).image,
        ),
        Container(
          height: 50,
        ),
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            child: Text(
              'Cadastrar Alguem',
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterJourney()));
            },
          ),
        )
      ],
    );
  }
}
