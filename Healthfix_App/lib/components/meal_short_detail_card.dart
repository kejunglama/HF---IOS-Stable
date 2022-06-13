// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:healthfix/models/Meal.dart';
// import 'package:logger/logger.dart';

import '../constants.dart';
import '../size_config.dart';

class MealShortDetailCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onPressed;
  // String variantId;
  num itemCount;
  // Function(DismissDirection direction, dynamic cartItemId)
  //     buildConfirmationToDelete;

  MealShortDetailCard({
    Key key,
    @required this.meal,
    @required this.onPressed,
    // this.variantId,
    this.itemCount,
    // this.buildConfirmationToDelete,
    // String variationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(variation != null && variation.isNotEmpty);
    // print(variantId);
    // Map variation;

    // print("item count --- ${itemCount}");
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // onLongPress: () {
      //   buildConfirmationToDelete(DismissDirection.startToEnd, mealId);
      // },
      child: Row(
        children: [
          SizedBox(
            width: getProportionateScreenWidth(76),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(0.03),
                ),
                margin: EdgeInsets.all(getProportionateScreenHeight(10)),
                child: meal.images.length > 0
                    ? Image.network(
                        meal.images[0],
                        fit: BoxFit.contain,
                      )
                    : Text("No Image"),
              ),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(20)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  itemCount != null
                      ? itemCount > 1
                          ? "x${itemCount.toString()} ${meal.title}"
                          : meal.title
                      : meal.title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: cusPdctNameStyle,
                  // maxLines: 1,
                ),
                // Visibility(
                //   visible: itemCount != null,
                //   child: Text(itemCount.toString()),
                // ),
                // Visibility(
                //   visible: (variation != null && variation.isNotEmpty),
                //   child: Text(
                //     (variation != null && variation.isNotEmpty)
                //         ? "${variation["size"]} - ${variation["color"]["name"]}"
                //         : "",
                //     style: cusPdctNameStyle,
                //   ),
                // ),
                // sizedBoxOfHeight(10),

                // Visibility(
                //   visible: itemCount != null,
                //   child: Text(itemCount.toString()),
                // ),

                Text.rich(
                  TextSpan(
                    text: currency.format(meal.originalPrice),
                    style: cusPdctDisPriceStyle(),
                    // children: [
                    //   TextSpan(
                    //       text: variation != null && variation.isNotEmpty
                    //           ? "\Rs. ${variation != null ? (variation["dis_price"] ?? variation["price"] * 1.2) : meal.originalPrice}"
                    //           : "",
                    //       style: meal.discountPrice != null
                    //           ? cusPdctOriPriceStyle()
                    //           : cusPdctDisPriceStyle()),
                    // ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
