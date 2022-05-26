// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductShortDetailCard extends StatelessWidget {
  final String productId;
  final VoidCallback onPressed;
  Map variation;
  num itemCount;

  ProductShortDetailCard({
    Key key,
    @required this.productId,
    @required this.onPressed,
    this.variation,
    this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(variation != null && variation.isNotEmpty);
    // print("item count --- ${itemCount}");
    return InkWell(
      onTap: onPressed,
      child: FutureBuilder<Product>(
        future: ProductDatabaseHelper().getProductWithID(productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = snapshot.data;
            return Row(
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(88),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.withOpacity(0.03),
                      ),
                      margin: EdgeInsets.all(10),
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
                      Visibility(
                        visible: (variation != null && variation.isNotEmpty),
                        child: Text(
                          (variation != null && variation.isNotEmpty) ? "${variation["size"]} - ${variation["color"]["name"]}" : "",
                          style: cusPdctNameStyle,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "\Rs. ${product.discountPrice}  ",
                          style: cusPdctDisPriceStyle(),
                          children: [
                            TextSpan(text: "\Rs. ${product.originalPrice}", style: cusPdctOriPriceStyle()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            final errorMessage = snapshot.error.toString();
            Logger().e(errorMessage);
          }
          return Center(
            child: Icon(
              Icons.error,
              color: kTextColor,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
