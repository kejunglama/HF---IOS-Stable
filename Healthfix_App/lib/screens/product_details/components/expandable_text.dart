import 'package:healthfix/screens/product_details/provider_models/ExpandText.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ExpandableText extends StatelessWidget {
  final String title;
  final String content;
  final int maxLines;
  const ExpandableText({
    Key key,
    @required this.title,
    @required this.content,
    this.maxLines = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpandText(),
      child: Consumer<ExpandText>(builder: (context, expandText, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: cusHeadingStyle(getProportionateScreenWidth(16)),
            ),
            SizedBox(height: getProportionateScreenHeight(6)),
            // Divider(
            //   height: 8,
            //   thickness: 1,
            //   endIndent: 16,
            // ),
            Text(
              content.trim().replaceAll("\\n", "\n"),
              softWrap: true,
              style: cusBodyStyle(),
              maxLines: expandText.isExpanded ? null : maxLines,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: getProportionateScreenHeight(6)),
            GestureDetector(
              onTap: () {
                expandText.isExpanded ^= true;
              },
              child: Row(
                children: [
                  Text(
                    expandText.isExpanded == false
                        ? "See more details"
                        : "Show less details",
                    style: cusHeadingLinkStyle,
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    expandText.isExpanded == false? Icons.keyboard_arrow_down_rounded: Icons.keyboard_arrow_up_rounded,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
