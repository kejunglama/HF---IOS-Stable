import 'package:flutter/material.dart';
import 'package:healthfix/screens/healthy_meal_description/components/body.dart';

class HealthyMealDescScreen extends StatelessWidget {
  String mealId;
  HealthyMealDescScreen(this.mealId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(mealId),
    );
  }
}
