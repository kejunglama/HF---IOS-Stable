// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';

import '../size_config.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData iconData;
  final GestureTapCallback press;
  final double size;

  const RoundedIconButton({
    Key key,
    @required this.iconData,
    @required this.press,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        alignment: Alignment.centerLeft,
        width: getProportionateScreenWidth(20),
        child: FlatButton(
          // onPressed: (){},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.zero,
          color: Colors.white,
          onPressed: press,
          child: Icon(
            iconData,
            color: kTextColor.withOpacity(0.8),
            size: getProportionateScreenHeight(18),
          ),
        ),
      ),
    );
  }
}
