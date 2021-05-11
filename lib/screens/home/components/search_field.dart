import 'package:AchaFacil/constants.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          onChanged: (value) => print(value),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(9),
                  vertical: getProportionateScreenWidth(20)),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Pesquisar serviços...",
              prefixIcon: Icon(Icons.search)),
        ),
      ),
    );
  }
}
