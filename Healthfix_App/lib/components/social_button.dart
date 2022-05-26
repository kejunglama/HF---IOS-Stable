// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// import '../constants.dart';
import '../size_config.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        // color: Colors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        onPressed: (){},
        child: Text(
          "text",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            // color: Colors.white,
          ),
        ),
      ),
    );
  }
}
