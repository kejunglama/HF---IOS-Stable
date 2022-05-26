import 'package:flutter/material.dart';
import 'package:healthfix/size_config.dart';

import '../constants.dart';

class AppBackBtn extends StatelessWidget {
  const AppBackBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(getProportionateScreenHeight(8)),
        child: Icon(
          Icons.keyboard_backspace_rounded,
          color: Colors.white,
        ),
        color: kPrimaryColor,
      ),
    );
  }
}