import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_short_detail_card.dart';
import 'package:healthfix/models/CartItem.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/services/data_streams/cart_items_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OrderItems extends StatefulWidget {
  List selectedCartItems;
  bool isBuyNow;

  OrderItems({
    Key key,
    this.selectedCartItems,
    this.isBuyNow,
  }) : super(key: key);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  final CartItemsStream cartItemsStream = CartItemsStream();

  @override
  void initState() {
    super.initState();
    cartItemsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    cartItemsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.markunread_mailbox_outlined, color: kSecondaryColor.withOpacity(0.8)),
            sizedBoxOfWidth(12),
            Text("OrderItems", style: cusCenterHeadingStyle(null, null, getProportionateScreenHeight(18))),
          ],
        ),
        // SizedBox(height: SizeConfig.screenHeight * 0.14, child: buildCartItemsList()),
        // buildCartItemsList(),
        buildSelectedCartItemsList(),
      ],
    );
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<String>>(
      stream: cartItemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> cartItemsId = snapshot.data;
          // print(snapshot.data);

          if (cartItemsId.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "Your cart is empty",
              ),
            );
          }

          return Container(
            height: SizeConfig.screenHeight * 0.14,
            child: Column(
              children: [
                // SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.isBuyNow ? 1 : cartItemsId.length,
                    itemBuilder: (context, index) {
                      if (index >= cartItemsId.length) {
                        return SizedBox(height: getProportionateScreenHeight(80));
                      }
                      return buildCartItem(cartItemsId[index], index);
                    },
                  ),
                ),
                // DefaultButton(
                //   text: "Proceed to Payment",
                //   press: () {
                //     bottomSheetHandler = Scaffold.of(context).showBottomSheet(
                //       (context) {
                //         return CheckoutCard(
                //           onCheckoutPressed: checkoutButtonCallback,
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildSelectedCartItemsList() {
    return Container(
      height: SizeConfig.screenHeight * 0.14,
      child: Column(
        children: [
          // SizedBox(height: getProportionateScreenHeight(20)),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 16),
              physics: BouncingScrollPhysics(),
              itemCount: widget.selectedCartItems.length,
              itemBuilder: (context, index) {
                if (index >= widget.selectedCartItems.length) {
                  return SizedBox(height: getProportionateScreenHeight(80));
                }
                return widget.isBuyNow ?? false
                    ? buildCartItemWithBuyNow(widget.selectedCartItems[index], index)
                    : buildCartItem(widget.selectedCartItems[index], index);
              },
            ),
          ),
          // DefaultButton(
          //   text: "Proceed to Payment",
          //   press: () {
          //     bottomSheetHandler = Scaffold.of(context).showBottomSheet(
          //       (context) {
          //         return CheckoutCard(
          //           onCheckoutPressed: checkoutButtonCallback,
          //         );
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget buildCartItem(String cartItemId, int index) {
    Future<Product> pdct = ProductDatabaseHelper().getProductWithID(cartItemId);
    Future<CartItem> cartItem = UserDatabaseHelper().getCartItemFromId(cartItemId);
    Map variation;
    int i = 1;
    int j = 1;

    return Container(
      width: SizeConfig.screenWidth * 0.7,
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FutureBuilder(
        future: Future.wait([pdct, cartItem]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data[0];
            int itemCount = 0;
            final cartItem = snapshot.data[1];
            // print(i);
            // if (i == 1) {
            if (cartItem.variation != null) {
              variation = cartItem.variation[0];
              // print({product.id: variation});
              itemCount = variation["item_count"];
              // print(i);
              print(product.title);
            } else {
              itemCount = cartItem.itemCount;
              // print(product.title);

              // print(itemCount);
              // print({
              //   product.id: {"item_count": itemCount}
              // });
              // }
            }
            i++;

            return SizedBox(
              child: ProductShortDetailCard(
                productId: product.id,
                itemCount: itemCount,
                variation: variation,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        productId: product.id,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildCartItemWithBuyNow(String cartItemId, int index) {
    Future<Product> pdct = ProductDatabaseHelper().getProductWithID(cartItemId);

    return Container(
      width: SizeConfig.screenWidth * 0.7,
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FutureBuilder(
        future: pdct,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Product product = snapshot.data;
            int itemCount = 1;

            return SizedBox(
              child: ProductShortDetailCard(
                productId: product.id,
                itemCount: itemCount,
                variation: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        productId: product.id,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          } else {
            return Center(
              child: Icon(
                Icons.error,
              ),
            );
          }
        },
      ),
    );
  }
}
