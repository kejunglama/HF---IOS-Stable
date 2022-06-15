import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
// import 'package:healthfix/size_config.dart';

import 'components/body.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders", style: cusHeadingStyle()),
      ),
      body: Body(),
    );
  }
}
