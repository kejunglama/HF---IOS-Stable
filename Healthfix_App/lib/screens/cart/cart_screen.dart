import 'package:flutter/material.dart';
// import 'package:healthfix/size_config.dart';

import '../../constants.dart';
import 'components/body.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart", style: cusCenterHeadingStyle(Colors.white)),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      body: Body(),
    );
  }
}
