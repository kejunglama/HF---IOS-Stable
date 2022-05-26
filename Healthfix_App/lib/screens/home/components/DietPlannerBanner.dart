import 'package:flutter/material.dart';
import 'package:healthfix/size_config.dart';

class DietPlanBanner extends StatelessWidget {
  String dietPlanBanner;
  DietPlanBanner(this.dietPlanBanner, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      child: AspectRatio(
        aspectRatio: 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            dietPlanBanner,
            alignment: Alignment.bottomCenter,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
