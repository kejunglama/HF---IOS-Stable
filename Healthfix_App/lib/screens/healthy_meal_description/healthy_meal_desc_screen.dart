import 'package:flutter/material.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/screens/healthy_meal_description/components/body.dart';

class HealthyMealDescScreen extends StatelessWidget {
  final String mealId;
  final Meal meal;
  HealthyMealDescScreen(this.mealId, {Key key, this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.purple,
          // toolbarHeight: 0,
          ),
      body: Body(mealId, meal),
    );
  }
}
