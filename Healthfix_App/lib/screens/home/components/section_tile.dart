import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

class SectionTile extends StatelessWidget {
  final String title;
  final GestureTapCallback onPress;

  const SectionTile({
    Key key,
    @required this.title,
    @required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: cusHeadingStyle(
                  fontSize: getProportionateScreenHeight(16),
                  fontWeight: FontWeight.w400,
                )),
            Visibility(
              visible: onPress != null,
              child: Text(
                "See More",
                style: cusHeadingLinkStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
