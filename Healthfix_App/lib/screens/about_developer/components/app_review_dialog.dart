import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/AppReview.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';

class AppReviewDialog extends StatelessWidget {
  final AppReview appReview;
  AppReviewDialog({
    Key key,
    @required this.appReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "Feedback",
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      children: [
        Center(
          child: TextFormField(
            initialValue: appReview.feedback,
            decoration: InputDecoration(
              hintText: "Feedback for App",
              labelText: "Feedback (optional)",
              floatingLabelBehavior: FloatingLabelBehavior.always,
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
              hintStyle: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
            ),
            onChanged: (value) {
              appReview.feedback = value;
            },
            maxLines: null,
            maxLength: 150,
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        Center(
          child: DefaultButton(
            text: "Submit",
            press: () {
              Navigator.pop(context, appReview);
            },
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
    );
  }
}
