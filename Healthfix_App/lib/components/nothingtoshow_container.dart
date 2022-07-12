import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NothingToShowContainer extends StatelessWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key key,
    this.iconPath = "assets/icons/empty_box.svg",
    this.primaryMessage = "Nothing to show",
    this.secondaryMessage = "",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth * 0.75,
      height: getProportionateScreenHeight(200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconPath,
            color: kTextColor,
            width: getProportionateScreenWidth(50),
          ),
          SizedBox(height: getProportionateScreenHeight(16)),
          Text(
            "$primaryMessage",
            style: cusHeadingStyle(
              color: kTextColor,
              fontSize: 16,
            ),
          ),
          Text(
            "$secondaryMessage",
            style: cusHeadingStyle(
              color: kTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
