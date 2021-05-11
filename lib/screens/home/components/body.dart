import 'package:AchaFacil/screens/home/components/home_header.dart';
import 'package:AchaFacil/screens/home/components/search_field.dart';
import 'package:AchaFacil/size_config.dart';
import 'package:flutter/material.dart';

import 'body_categories_list.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(),
            SizedBox(height: getProportionateScreenHeight(10)),
            SearchField(),
            SizedBox(height: getProportionateScreenWidth(10)),
            BodyCategoriesList(),
          ],
        ),
      ),
    );
  }
}
