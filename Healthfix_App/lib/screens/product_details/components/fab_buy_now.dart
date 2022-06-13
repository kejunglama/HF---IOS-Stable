import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

class BuyNowFAB extends StatelessWidget {
  final String productId;
  final Function onTap;

  BuyNowFAB({
    Key key,
    @required this.productId,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(40),
      child: FloatingActionButton.extended(
        extendedPadding: EdgeInsets.all(getProportionateScreenHeight(12)),
        heroTag: "buyNow",
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(new Radius.circular(40.0)),
          side: BorderSide(color: kPrimaryColor, width: 1),
        ),
        onPressed: onTap,
        elevation: 0,
        label: Text(
          "Buy Now",
          style: cusHeadingStyle(
              fontSize: getProportionateScreenHeight(14), color: kPrimaryColor),
        ),
      ),
    );
  }
}
