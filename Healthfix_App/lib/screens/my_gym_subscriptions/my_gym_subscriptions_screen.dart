import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';

import 'components/body.dart';

class MyGymSubscriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gym Subscription", style: cusHeadingStyle()),
      ),
      body: Body(),
    );
  }
}
