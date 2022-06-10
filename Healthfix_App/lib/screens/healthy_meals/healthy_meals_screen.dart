import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/healthy_meals/components/body.dart';
import 'package:healthfix/size_config.dart';

class HealthyMealsScreen extends StatelessWidget {
  const HealthyMealsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Healthy Meals",
                style: cusHeadingStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontWeight: FontWeight.w300)),
            Text(" from Fitcal",
                style: cusHeadingStyle(
                    fontSize: getProportionateScreenHeight(20),
                    color: Colors.purple,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        backgroundColor: kPrimaryColor.withOpacity(0.05),
        // foregroundColor: Colors.grey.withOpacity(0.8),
      ),
      body: Body(),
    );
  }
}
