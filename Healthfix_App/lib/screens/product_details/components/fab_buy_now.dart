import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import '../../../utils.dart';

class BuyNowFAB extends StatelessWidget {
  final String productId;
  Function onTap;

  BuyNowFAB({
    Key key,
    @required this.productId,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
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
        style: cusHeadingStyle(getProportionateScreenWidth(14), kPrimaryColor),
      ),
    );
  }
}
