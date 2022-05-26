import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/sign_up/components/sign_up_form.dart';
import 'package:healthfix/size_config.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          height: SizeConfig.screenHeight * 0.95,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // SizedBox(height: SizeConfig.screenHeight * 0.02),
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
                    "Let’s Get Started",
                    style: headingStyle,
                  ),
                  Text(
                    "Complete your details to Create a New Account",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              // SizedBox(height: SizeConfig.screenHeight * 0.07),
              SignUpForm(),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                "By continuing your confirm that you agree \nwith our Terms and Conditions",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
