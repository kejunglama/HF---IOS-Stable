import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

// Cleaned
class ProductTypeBox extends StatelessWidget {
  final String imageLocation;
  final String title;
  final VoidCallback onPress;

  const ProductTypeBox({
    Key key,
    @required this.imageLocation,
    @required this.title,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(imageLocation);
    return InkWell(
      onTap: onPress,
      child: Column(
        children: [
          Container(
            height: getProportionateScreenHeight(70),
            width: getProportionateScreenHeight(70),
            margin: EdgeInsets.only(
              left: getProportionateScreenHeight(12),
            ),
            // padding: EdgeInsets.all(getProportionateScreenHeight(18)),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(6)),
              child: AspectRatio(
                aspectRatio: 1,
                // child: SvgPicture.asset(
                //   icon,
                //   color: kPrimaryColor,
                // ),
                child: Container(
                  child: Image.asset(imageLocation),
                ),
              ),
            ),
          ),
          // SizedBox(height: 2),
          Container(
            margin: EdgeInsets.only(left: getProportionateScreenHeight(12), top: getProportionateScreenHeight(5)),
            width: getProportionateScreenWidth(70),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: cusPdctCatNameStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
