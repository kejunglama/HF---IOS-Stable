import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';

import 'components/body.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shop by Category",
          style: cusCenterHeadingStyle(Colors.white),
        ),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      body: Body(),
    );
  }
}
