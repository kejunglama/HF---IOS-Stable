import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/home/components/top_brand_card.dart';
import 'package:healthfix/size_config.dart';

class TopBrandsSection extends StatelessWidget {
  final List<String> topBrandsList;

  const TopBrandsSection(this.topBrandsList, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Top Brands | ", style: cusCenterHeadingStyle()),
              Text("We Trust", style: cusCenterHeadingAccentStyle),
            ],
          ),

          sizedBoxOfHeight(12),

          // SizedBox(height: getProportionateScreenHeight(10)),

          // SizedBox(
          //   height: 532,
          //   child: GridView.count(
          //     crossAxisCount: 2,
          //     children: List.generate(
          //       4,
          //       (index) => Container(
          //         height: 100,
          //         child: TopCategoryCard(),
          //       ),
          //     ),
          //   ),
          // ),
          Container(
            color: kPrimaryColor.withOpacity(0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: getProportionateScreenHeight(12)),
                TopBrandCardRow(topBrandsList: topBrandsList.sublist(0)),
                SizedBox(height: getProportionateScreenHeight(12)),
                TopBrandCardRow(topBrandsList: topBrandsList.sublist(3)),
                SizedBox(height: getProportionateScreenHeight(12)),
                TopBrandCardRow(topBrandsList: [
                  topBrandsList[2],
                  topBrandsList[0],
                  topBrandsList[3],
                ]),
                SizedBox(height: getProportionateScreenHeight(12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
