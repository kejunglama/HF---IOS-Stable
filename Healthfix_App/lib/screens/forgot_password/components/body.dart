import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/forgot_password/components/forgot_password_form.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            height: SizeConfig.screenHeight * 0.95,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.2),
                Column(
                  children: [
                    Text(
                      "Forgot Password",
                      style: cusHeadingStyle(getProportionateScreenWidth(20), kPrimaryColor),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Text(
                      "Please enter your email and we will send \nyou a link to return to your account",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                ForgotPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
