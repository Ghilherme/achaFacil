import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Todos',
                  style: GoogleFonts.quicksand(
                      color: Theme.of(context).primaryColor,
                      textStyle: Theme.of(context).textTheme.headline6),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Melhores avaliados',
                  style: GoogleFonts.quicksand(
                      color: Theme.of(context).primaryColor,
                      textStyle: Theme.of(context).textTheme.headline6),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '24h',
                  style: GoogleFonts.quicksand(
                      color: Theme.of(context).primaryColor,
                      textStyle: Theme.of(context).textTheme.headline6),
                ),
              ],
            ),
          ],
        ));
  }
}
