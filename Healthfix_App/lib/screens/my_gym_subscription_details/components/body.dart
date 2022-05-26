import 'package:flutter/material.dart';
import 'package:healthfix/models/GymSubscription.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  GymSubscription gymSubscription;

  Body(this.gymSubscription);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.all(getProportionateScreenHeight(12)),
      child: Card(
        elevation: 12,
        shadowColor: Colors.black26,
        child: Container(
          padding: EdgeInsets.all(getProportionateScreenHeight(8)),
          child: Column(
            children: [
              buildHeading(),
              sizedBoxOfHeight(24),
              buildDataRow("Subscription ID", gymSubscription.id),
              buildDataRow("Gym Name", gymSubscription.gymName),
              buildDataRow("Gym ID", gymSubscription.gymID),
              buildDataRow("Subscribed on", gymSubscription.subscribedOn),
              buildDataRow("Starting From", gymSubscription.startingFrom),
              buildDataRow("Package Duration", gymSubscription.package["duration"]),
              buildDataRow("Package Price", currency.format(gymSubscription.package["price"]).toString()),
            ],
          ),
        ),
      ),
    );
  }

  Column buildDataRow(String title, var data) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(8.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: cusBodyStyle(16, null, Colors.grey)),
              Text(data, style: cusBodyStyle(16)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
          child: Divider(
            color: Colors.black12,
          ),
        ),
      ],
    );
  }

  Row buildHeading() {
    return Row(
      children: [
        Container(
          height: getProportionateScreenHeight(40),
          width: getProportionateScreenHeight(40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kPrimaryColor.withOpacity(0.12),
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            color: kPrimaryColor,
          ),
        ),
        sizedBoxOfWidth(20),
        Text(
          "${gymSubscription.gymName}",
          style: cusHeadingStyle(getProportionateScreenHeight(16)),
        ),
      ],
    );
  }
}
