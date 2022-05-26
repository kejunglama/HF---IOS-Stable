import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

// Cleaned
class OurFeatureCard extends StatelessWidget {
  final Icon icon;
  final String heading;
  final String subHeading;

  const OurFeatureCard(this.icon, this.heading, this.subHeading, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: getProportionateScreenHeight(8)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(width: 0.05, color: Colors.black12),
          ),
          child: Padding(
            padding: EdgeInsets.all(getProportionateScreenHeight(15)),
            child: Row(
              children: [
                Container(
                  width: getProportionateScreenWidth(40),
                  height: getProportionateScreenWidth(40),
                  child: icon,
                ),
                Container(
                  width: getProportionateScreenWidth(250),
                  child: Padding(
                    padding: EdgeInsets.only(left: getProportionateScreenWidth(18)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            heading,
                            textAlign: TextAlign.start,
                            style: cusHeadingStyle(getProportionateScreenWidth(16), kSecondaryColor),
                          ),
                        ),
                        // SizedBox(height: getProportionateScreenHeight(2)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(subHeading, style: cusBodyStyle()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenHeight(4)),
      ],
    );
  }
}
