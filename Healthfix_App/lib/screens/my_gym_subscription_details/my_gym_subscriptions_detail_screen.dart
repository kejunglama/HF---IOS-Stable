import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/GymSubscription.dart';

import 'components/body.dart';

class GymSubscriptionDetails extends StatelessWidget {
  GymSubscription gymSubscription;

  GymSubscriptionDetails(this.gymSubscription);

  @override
  Widget build(BuildContext context) {
    print(gymSubscription);
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscription Detail", style: cusHeadingStyle(),),
      ),
      body: Body(gymSubscription),
    );
  }
}
