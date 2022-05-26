import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/home/components/our_feature_card.dart';
import 'package:healthfix/size_config.dart';

class OurFeaturesSection extends StatelessWidget {
  const OurFeaturesSection({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(8)),
            OurFeatureCard(
              Icon(Icons.verified_user_outlined, size: getProportionateScreenHeight(30), color: kSecondaryColor),
              "Authentic Products",
              "We deliver authentic products to you.",
            ),
            OurFeatureCard(
              Icon(Icons.delivery_dining_outlined, size: getProportionateScreenHeight(30), color: kSecondaryColor),
              "Same Day Delivery",
              "We deliver on the same day you order.",
            ),
            OurFeatureCard(
              Icon(Icons.restart_alt_rounded, size: getProportionateScreenHeight(30), color: kSecondaryColor),
              "Return Policy",
              "We have return policy on our products.",
            ),
          ],
        ),
      ),
    );
  }
}
