// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:healthfix/models/Product.dart';

import '../../../size_config.dart';
import '../../../constants.dart';

class OrderProductShortDetailCard extends StatelessWidget {
  final String productId;
  final VoidCallback onPressed;
  String variantId;
  Product product;
  num itemCount;
  Function(DismissDirection direction, dynamic cartItemId)
      buildConfirmationToDelete;

  OrderProductShortDetailCard({
    Key key,
    this.productId,
    @required this.onPressed,
    this.variantId,
    this.itemCount,
    this.buildConfirmationToDelete,
    String variationId,
    @required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(variation != null && variation.isNotEmpty);
    // print(variantId);
    Map variation;

    bool hasVariations = product.variations != null;
    bool hasSizeVariation = false;
    bool hasColorVariation = false;
    String variantText = "";
    print("product ${product.variations}");
    print("variantId ${variantId}");
    if (hasVariations) {
      variation = product.variations
          .where((variant) => variant["var_id"] == variantId)
          .first;

      hasSizeVariation = variation["size"] != null;
      hasColorVariation = variation["color"] != null;
      // print(
      //     "hasSizeVariation $hasSizeVariation $variantId ${variation["size"]}");

      variantText =
          "${hasSizeVariation ? "Size: ${variation["size"]}" : ""}${hasSizeVariation && hasColorVariation ? " - " : ""}${hasColorVariation ? ("Color: ${variation["color"]["name"]} - ") : ""}";
    }

    // print("item count --- ${itemCount}");
    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      // onLongPress: () {
      //   buildConfirmationToDelete(DismissDirection.startToEnd, productId);
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
                child: product.images.length > 0
                    ? Image.network(
                        product.images[0],
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
                          ? "x${itemCount.toString()} ${product.title}"
                          : product.title
                      : product.title,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: cusPdctNameStyle,
                  maxLines: (product.variations == null) ? 2 : 1,
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
                Visibility(
                  visible: (hasVariations),
                  child: Row(
                    children: [
                      Text(
                        variantText,
                        style: cusPdctCatNameStyle,
                      ),
                      Container(
                          height: getProportionateScreenHeight(10),
                          width: getProportionateScreenHeight(10),
                          decoration: BoxDecoration(
                            color: variation != null && variation.isNotEmpty
                                ? Color(int.parse(hasColorVariation
                                    ? "0xFF" + variation["color"]["hex"]
                                    : "0xFFFFFFFF"))
                                : null,
                            borderRadius: BorderRadius.circular(
                              getProportionateScreenWidth(20),
                            ),
                          )),
                    ],
                  ),
                ),
                sizedBoxOfHeight(10),

                Text.rich(
                  TextSpan(
                    text: variation != null
                        ? "\Rs. ${variation["price"]} "
                        : product.discountPrice != null
                            ? "\Rs. ${product.discountPrice} "
                            : "",
                    style: cusPdctDisPriceStyle(),
                    children: [
                      TextSpan(
                          text: variation != null && variation.isNotEmpty
                              ? "\Rs. ${variation != null ? (variation["dis_price"] ?? variation["price"] * 1.2) : product.originalPrice}"
                              : "",
                          style: product.discountPrice != null
                              ? cusPdctOriPriceStyle()
                              : cusPdctDisPriceStyle()),
                    ],
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
