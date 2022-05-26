import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';

import '../../../components/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_in_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(screenPadding)),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: SizeConfig.screenHeight * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Column(
                    children: [
                      Container(
                        height: SizeConfig.screenHeight * 0.10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset("assets/logo/hf-logo-only.png"),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      // Title and Subtitle
                      Text(
                        "Welcome to Healthfix",
                        style: headingStyle,
                      ),
                      Text(
                        "Log in with your Email and Password",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SignInForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
