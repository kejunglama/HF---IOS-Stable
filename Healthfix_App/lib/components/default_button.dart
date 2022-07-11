// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color;
  final String iconImageURL;
  const DefaultButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.iconImageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasWhiteBG = color == Colors.white;
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(width: getProportionateScreenHeight(0.5), color: hasWhiteBG ? Colors.grey : kPrimaryColor),
        ),
        onPressed: press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: iconImageURL != null,
              child: Row(
                children: [
                  SizedBox(
                    width: getProportionateScreenHeight(30),
                    height: getProportionateScreenHeight(30),
                    child: Image.asset(iconImageURL ?? ""),
                  ),
                  sizedBoxOfWidth(getProportionateScreenWidth(10)),
                ],
              ),
            ),
            Text(
              text,
              style: cusHeadingStyle(
                fontSize: getProportionateScreenWidth(16),
                color: hasWhiteBG ? Colors.black : Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
