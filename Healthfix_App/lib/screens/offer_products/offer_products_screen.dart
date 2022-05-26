import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/body.dart';

class OfferProductsScreen extends StatelessWidget {
  const OfferProductsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("", style: cusHeadingStyle()),
      ),
      body: Body(),
    );
  }
}
