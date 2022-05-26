import 'package:flutter/material.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/size_config.dart';

import '../../constants.dart';


class AddressScreen extends StatelessWidget {
  const AddressScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Delivery Address",
          style: cusHeadingStyle(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                buildHintText("Name"),
                buildTextFormField("Your Name"),
                // buildHintText("Email"),
                // buildHintText("Kejunglama@gmail.com", isData: true),
                // buildHintText("Contact Number"),
                // buildTextFormField("Your Contact"),
                buildHintText("Delivery Address"),
                buildTextFormField("eg. 1234 Forest Road"),
                buildHintText("City"),
                buildTextFormField("eg. Kathmandu"),
              ],
            ),
            DefaultButton(
              text: "Save your Address",
              press: () {},
            ),
            // buildHintText("District"),
            // buildTextFormField("1234 Forest Road"),
          ],
        ),
      ),
    );
  }

  Container buildHintText(String text, {bool isData}) {
    bool _isData = isData ?? false;
    return Container(
      alignment: Alignment.centerLeft,
      padding: _isData ? EdgeInsets.only(bottom: getProportionateScreenHeight(12)) : EdgeInsets.symmetric(vertical: getProportionateScreenHeight(12)),
      child: Text(
        text,
        style: _isData ? cusBodyStyle(14, null, null, 1) : cusBodyStyle(16, null, null, 1),
      ),
    );
  }

  Container buildTextFormField(String hint) {
    return Container(
      height: getProportionateScreenHeight(36),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.cyan, width: 0.1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hint,
          hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
          // labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
