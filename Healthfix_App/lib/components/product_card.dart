import 'package:flutter/material.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import '../constants.dart';

class ProductCard extends StatefulWidget {
  String productId;
  final GestureTapCallback press;
  final bool noSpacing;

  ProductCard({
    Key key,
    @required this.productId,
    @required this.press,
    this.noSpacing,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  void initState() {
    // productFuture = ProductDatabaseHelper().getProductWithID(widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<Product> productFuture = ProductDatabaseHelper().getProductWithID(widget.productId);

    return GestureDetector(
      onTap: widget.press,
      child: Container(
        // height: 300,
        margin: widget.noSpacing ?? false ? null : EdgeInsets.only(left: getProportionateScreenWidth(12)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kTextColor.withOpacity(0.15)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(12), vertical: getProportionateScreenHeight(12)),
          child: FutureBuilder<Product>(
            future: productFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Product product = snapshot.data;
                return buildProductCardItems(product);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                final error = snapshot.error.toString();
                Logger().e(error);
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
        ),
      ),
    );
  }

  Column buildProductCardItems(Product product) {
    bool hasDisPrice = product.discountPrice != null;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: getProportionateScreenHeight(80),
          height: getProportionateScreenHeight(80),
          color: Colors.grey.withOpacity(0.2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              product.images[0],
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(14)),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product.title.trim()}\n",
                style: cusPdctNameStyle(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Visibility(
                visible: product.priceRange != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Starting From",
                      style: cusBodyStyle(fontSize: getProportionateScreenHeight(10)),
                    ),
                    Text("${currency.format(product.priceRange != null ? product.priceRange : 0)}",
                        style: cusPdctDisPriceStyle()),
                  ],
                ),
              ),
              Visibility(
                visible: product.variations == null,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: hasDisPrice,
                      child: Text(
                        "\Rs. ${product.discountPrice}",
                        style: cusPdctDisPriceStyle(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("\Rs. ${product.originalPrice}",
                            style: hasDisPrice ? cusPdctOriPriceStyle() : cusPdctDisPriceStyle()),
                        Visibility(
                          visible: hasDisPrice,
                          child: Text(
                            "${hasDisPrice ? product.calculatePercentageDiscount() : null}% OFF",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: getProportionateScreenHeight(8),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
