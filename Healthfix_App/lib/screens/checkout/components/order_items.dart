import 'package:flutter/material.dart';
import 'package:healthfix/components/meal_short_detail_card.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_short_detail_card.dart';
import 'package:healthfix/models/CartItem.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/healthy_meal_description/healthy_meal_desc_screen.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';

import 'package:healthfix/services/data_streams/cart_product_id_stream.dart';
import 'package:healthfix/services/database/meals_database_helper.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'order_item.dart';

class OrderItems extends StatefulWidget {
  final List selectedCartItems;
  final bool isBuyNow;
  final bool isMeal;

  OrderItems({
    Key key,
    this.selectedCartItems,
    this.isBuyNow,
    this.isMeal,
  }) : super(key: key);

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  final CartProductIdStream cartProductIdStream = CartProductIdStream();

  @override
  void initState() {
    super.initState();
    cartProductIdStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    cartProductIdStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.markunread_mailbox_outlined,
              color: kSecondaryColor.withOpacity(0.8),
              size: getProportionateScreenHeight(20),
            ),
            sizedBoxOfWidth(12),
            Text("OrderItems",
                style: cusCenterHeadingStyle(
                    null, null, getProportionateScreenHeight(18))),
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
      stream: cartProductIdStream.stream,
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
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(16)),
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.isBuyNow ? 1 : cartItemsId.length,
                    itemBuilder: (context, index) {
                      if (index >= cartItemsId.length) {
                        return SizedBox(
                            height: getProportionateScreenHeight(80));
                      }
                      print("order Items : $cartItemsId");
                      return Container();
                      // return buildCartItem(cartItemsId[index], index);
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
      height: getProportionateScreenHeight(160),
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
                    ? buildCartItemWithBuyNow(
                        widget.selectedCartItems[index],
                        index,
                        widget.isMeal,
                      )
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

  Widget buildCartItem(Map cartItemIdMap, int index) {
    String cartItemId = cartItemIdMap["var_id"] ?? cartItemIdMap["product_id"];

    Future<CartItem> cartItemFuture =
        UserDatabaseHelper().getCartItemFromId(cartItemId);

    // print("cartItemId $cartItemId");
    Map variation;

    String VARIANT_ID = "var_id";
    // int i = 1;
    // int j = 1;

    return Container(
      width: SizeConfig.screenWidth * 0.7,
      padding: EdgeInsets.only(
        bottom: getProportionateScreenHeight(4),
        top: getProportionateScreenHeight(4),
        right: getProportionateScreenHeight(4),
      ),
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(4),
          horizontal: getProportionateScreenHeight(4)),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FutureBuilder(
        future: cartItemFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CartItem cartItem = snapshot.data;

            // print("cartItem $cartItem");
            // print("product Id ${cartItem.productId ?? cartItem.id}");

            Future<Product> pdctFuture = ProductDatabaseHelper()
                .getProductWithID(cartItem.productId ?? cartItem.id);

            return FutureBuilder(
                future: pdctFuture,
                builder: (context, pdctSnapshot) {
                  if (pdctSnapshot.hasData) {
                    Product product = pdctSnapshot.data;
                    // print("order items - product - $product");
                    int itemCount = 0;
                    // print(i);
                    // if (i == 1) {
                    if (cartItem.productId != null) {
                      // variation = cartItem.variation[0];
                      variation = product.variations
                          .where(
                              (variant) => variant[VARIANT_ID] == cartItem.id)
                          .first;
                      // print({product.id: variation});
                      itemCount = variation["item_count"];
                      // print(i);
                      // print(product.title);
                    } else {
                      itemCount = cartItem.itemCount;
                      // print(product.title);

                      // print(itemCount);
                      // print({
                      //   product.id: {"item_count": itemCount}
                      // });
                      // }
                    }
                    // i++;

                    return SizedBox(
                      child: OrderProductShortDetailCard(
                        // productId: product.id,
                        product: product,
                        itemCount: itemCount,
                        variantId: cartItem.id,
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
                  } else if (pdctSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (pdctSnapshot.hasError) {
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
                });
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

  Widget buildCartItemWithBuyNow(String cartItemId, int index, [bool isMeal]) {
    Future<Product> pdctFuture =
        ProductDatabaseHelper().getProductWithID(cartItemId);
    Future<Meal> mealFuture;
    print("cartItemId");
    print(cartItemId);
    print(isMeal);
    if (isMeal ?? false) {
      mealFuture = MealsDatabaseHelper().getMealsWithID(cartItemId);
    }

    return Container(
      width: SizeConfig.screenWidth * 0.7,
      padding: EdgeInsets.only(bottom: 4, top: 4, right: 4),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: isMeal ?? false
          ? FutureBuilder(
              future: mealFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Meal meal = snapshot.data;
                  int itemCount = 1;
                  print("meal");
                  print(meal);
                  return SizedBox(
                    child: MealShortDetailCard(
                      meal: meal,
                      itemCount: itemCount,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HealthyMealDescScreen(meal.id),
                            ));
                      },
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  Logger().w(snapshot.error.toString());
                  return Center(child: Text(error.toString()));
                } else {
                  return Center(child: Icon(Icons.error));
                }
              },
            )
          : FutureBuilder(
              future: pdctFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Product product = snapshot.data;
                  int itemCount = 1;

                  return SizedBox(
                    child: ProductShortDetailCard(
                      productId: product.id,
                      itemCount: itemCount,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsScreen(productId: product.id),
                            ));
                      },
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  final error = snapshot.error;
                  Logger().w(snapshot.error.toString());
                  return Center(child: Text(error.toString()));
                } else {
                  return Center(child: Icon(Icons.error));
                }
              },
            ),
    );
  }
}
