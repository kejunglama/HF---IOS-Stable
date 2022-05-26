import 'package:flutter/cupertino.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

class TopCategoryCard extends StatelessWidget {
  final String imageURL;

  const TopCategoryCard(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(160),
      height: getProportionateScreenHeight(160),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(imageURL,fit: BoxFit.cover),
        ),
      ),
    );
  }
}
