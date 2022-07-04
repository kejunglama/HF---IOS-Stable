import 'package:flutter/material.dart';
import 'package:healthfix/screens/healthy_meals/healthy_meals_screen.dart';
import 'package:healthfix/size_config.dart';

class MealsBanner extends StatelessWidget {
  final String dietPlanBanner;
  MealsBanner(this.dietPlanBanner, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => HealthyMealsScreen()));
      },
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: AspectRatio(
          aspectRatio: 2000 / 600,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              dietPlanBanner,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
