import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/models/Review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductReviewDialog extends StatelessWidget {
  final Review review;
  ProductReviewDialog({
    Key key,
    @required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "Review",
          style: TextStyle(fontSize: getProportionateScreenHeight(20)),
        ),
      ),
      children: [
        Center(
          child: RatingBar.builder(
            initialRating: review.rating.toDouble(),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemSize: getProportionateScreenHeight(40),
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              review.rating = rating.round();
            },
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(40)),
        Center(
          child: TextFormField(
            initialValue: review.feedback,
            minLines: 4,
            decoration: InputDecoration(
              hintText: "Your Feedback",
              labelText: "Your Feedback",
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
              hintStyle: cusHeadingStyle(getProportionateScreenHeight(14),
                  Colors.grey, null, FontWeight.w400),
            ),
            style: TextStyle(fontSize: getProportionateScreenHeight(16)),
            onChanged: (value) {
              review.feedback = value;
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
              Navigator.pop(context, review);
            },
          ),
        ),
      ],
      contentPadding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenHeight(12),
        vertical: getProportionateScreenHeight(16),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    );
  }
}
