import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/screens/checkout/checkout_screen.dart';
import 'package:healthfix/screens/healthy_meal_description/components/temp.dart';
import 'package:healthfix/screens/product_details/components/fab_add_to_cart.dart';
import 'package:healthfix/screens/product_details/components/fab_buy_now.dart';
import 'package:healthfix/screens/product_details/components/product_images.dart';
import 'package:healthfix/services/database/meals_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/shared_preference.dart';
import 'package:healthfix/size_config.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../components/nothingtoshow_container.dart';

class Body extends StatelessWidget {
  final String mealId;
  const Body(this.mealId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: MealsDatabaseHelper().getMealsWithID(mealId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Meal meal = snapshot.data;
            print(meal);
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(8.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                meal.title.capitalize(),
                                textAlign: TextAlign.center,
                                style: cusHeadingStyle(
                                    fontSize: getProportionateScreenHeight(22)),
                              ),
                              sizedBoxOfHeight(12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "240 gm - ",
                                    style: cusBodyStyle(
                                        getProportionateScreenHeight(20)),
                                  ),
                                  Text(
                                    "${currency.format(meal.originalPrice)}",
                                    style: cusPdctDisPriceStyle(
                                        getProportionateScreenHeight(20)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: getProportionateScreenHeight(280),
                          padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(20)),
                          // child: ProductImages(
                          //     imageList: meal.images,
                          //     imageFit: BoxFit.contain)
                          child: Center(
                              child: Image.network(meal.images[0],
                                  fit: BoxFit.cover)),
                        ),

                        buildFactValues(meal.values),
                        // sizedBoxOfHeight(24),
                        // Text(
                        //   "${meal.brand?.toUpperCase()}",
                        //   style: cusHeadingStyle(
                        //       fontSize: getProportionateScreenHeight(14),
                        //       color: Colors.black87,
                        //       fontWeight: FontWeight.w500),
                        // ),
                        // sizedBoxOfHeight(12),
                        // Text(
                        //   meal.title.capitalize(),
                        //   style: GoogleFonts.montserrat(
                        //       textStyle: TextStyle(
                        //           fontSize: getProportionateScreenHeight(24),
                        //           color: kSecondaryColor)),
                        // ),
                        sizedBoxOfHeight(20),
                        // buildInfoTabs(meal.desc, meal.highlights),
                        Container(
                          child: CusTabs(
                            tabsHeader: [
                              Tab(text: 'About'),
                              Tab(text: 'Ingredients'),
                              Tab(text: 'Reviews'),
                            ],
                            tabsBody: [
                              Text(
                                  meal.desc != null
                                      ? meal.desc.trim().replaceAll("\\n", "\n")
                                      : "",
                                  style: cusBodyStyle()),
                              Text(
                                  meal.ingredients != null
                                      ? meal.ingredients
                                          .trim()
                                          .replaceAll("\\n", "\n")
                                      : "",
                                  style: cusBodyStyle()),
                              Text("No Reviews yet.", style: cusBodyStyle()),
                            ],
                          ),
                        ),
                        // Text(
                        //   "${meal.highlights}",
                        //   style: cusHeadingStyle(
                        //       fontSize: getProportionateScreenHeight(14),
                        //       color: Colors.black87,
                        //       fontWeight: FontWeight.w500),
                        // ),
                        // Text("Details", style: cusHeadingStyle()),
                        sizedBoxOfHeight(100),
                        // Text(
                        //   meal.desc != null
                        //       ? meal.desc.trim().replaceAll("\\n", "\n")
                        //       : "",
                        //   style: cusBodyStyle(),
                        // ),
                      ],
                    ),
                  ),
                ),
                bottomBtnBar(context, meal),
              ],
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
        });
  }

  Column buildSingleValue(String data, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon(Icons.ene ),
        Text(data, style: cusHeadingStyle()),
        Text(key,
            style: cusBodyStyle(
                getProportionateScreenHeight(16), null, kSecondaryColor)),
      ],
    );
  }

  Widget buildFactValues(Map values) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.all(getProportionateScreenHeight(20)),
        child: Wrap(
          spacing: getProportionateScreenWidth(40),
          runSpacing: getProportionateScreenWidth(40),
          children: [
            for (var meal in values.entries)
              buildSingleValue(meal.value, meal.key),
          ],
        ),
      ),
    );
  }

  Widget buildInfoTabs(String description, String ingredients) {
    return Expanded(
      child: DefaultTabController(
        length: 3, // length of tabs
        initialIndex: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: TabBar(
                labelColor: kPrimaryColor,
                unselectedLabelColor: Colors.black,
                labelStyle: cusBodyStyle(),
                tabs: [
                  Tab(text: "About"),
                  Tab(text: "Ingredients"),
                  Tab(text: "Reviews"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                // height: 400, //height of TabBarView
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.5))),
                child: TabBarView(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          description != null
                              ? description.trim().replaceAll("\\n", "\n")
                              : "",
                          style: cusBodyStyle(),
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          ingredients != null
                              ? ingredients.trim().replaceAll("\\n", "\n")
                              : "",
                          style: cusBodyStyle(),
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          'No Reviews yet.',
                          style: cusBodyStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Positioned bottomBtnBar(BuildContext context, Meal meal) {
    UserPreferences prefs = new UserPreferences();
    bool hasDisPrice = meal.discountPrice != null;
    final numFormat = NumberFormat('#,##,000');

    // print("new color is set to $_selectedColor $_productDisPrice");
    Future<void> selectedCheckoutButtonCallbackForMeals(
        Map orderDetails, List selectedCartItems) async {
      final formatedDateTime = cusDateTimeFormatter.format(DateTime.now());

      OrderedProduct order = OrderedProduct(
        null,
        meals: selectedCartItems,
        orderDate: formatedDateTime,
        orderDetails: orderDetails,
      );
      bool addedProductsToMyProducts = false;
      String snackbarmMessage;
      try {
        addedProductsToMyProducts =
            await UserDatabaseHelper().addToMyOrders(order);
        if (addedProductsToMyProducts) {
          snackbarmMessage = "Products ordered Successfully";
        } else {
          throw "Could not order products due to unknown issue";
        }
      } on FirebaseException catch (e) {
        Logger().e(e.toString());
        snackbarmMessage = e.toString();
      } catch (e) {
        Logger().e(e.toString());
        snackbarmMessage = e.toString();
      } finally {
        Navigator.of(context).popUntil((route) => route.isFirst);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              snackbarmMessage ?? "Something went wrong",
              style: TextStyle(fontSize: getProportionateScreenHeight(16)),
            ),
          ),
        );
      }
    }

    Future<void> selectedCheckoutButtonFromBuyNowCallback(
        Map orderDetails, List selectedProductsUid) async {
      if (selectedProductsUid != null) {
        // print(orderedProductsUid);

        final formatedDateTime =
            cusDateTimeFormatter.format(DateTime.now()).toString();

        List orderedProducts = [];
        orderedProducts.add({
          OrderedProduct.PRODUCT_UID_KEY: selectedProductsUid[0],
          OrderedProduct.ITEM_COUNT_KEY: 1,
        });
        OrderedProduct order = OrderedProduct(null,
            products: orderedProducts,
            orderDate: formatedDateTime,
            orderDetails: orderDetails);
        // print(order);

        bool addedProductsToMyProducts = false;
        String snackbarmMessage;
        try {
          addedProductsToMyProducts =
              await UserDatabaseHelper().addToMyOrders(order);
          if (addedProductsToMyProducts) {
            snackbarmMessage = "Products ordered Successfully";
          } else {
            throw "Could not order products due to unknown issue";
          }
        } on FirebaseException catch (e) {
          Logger().e(e.toString());
          snackbarmMessage = e.toString();
        } catch (e) {
          Logger().e(e.toString());
          snackbarmMessage = e.toString();
        } finally {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarmMessage ?? "Something went wrong"),
            ),
          );
        }
      }
    }

    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.2),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: Offset(0, 3), // changes position of shadow
          //   ),
          // ],
        ),
        padding: EdgeInsets.all(getProportionateScreenWidth(10)),
        height: getProportionateScreenHeight(80),
        width: SizeConfig.screenWidth,
        child: Row(
          children: [
            Visibility(
              visible: false,
              child: Expanded(
                child: SizedBox(
                  height: getProportionateScreenHeight(70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Visibility(
                      //   visible: product.variations != null && !_selected,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Starting From",
                      //         style:
                      //             cusBodyStyle(getProportionateScreenHeight(14)),
                      //       ),
                      //       Text(
                      //           "${currency.format(product.priceRange != null ? product.priceRange : 0)}",
                      //           style: cusHeadingStyle(null, kPrimaryColor)),
                      //     ],
                      //   ),
                      // ),
                      Visibility(
                        // visible: product.variations == null || _selected,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: hasDisPrice,
                              child: Text(
                                "Rs. ${hasDisPrice ? (numFormat.format(meal.discountPrice ?? 0)) : null}  ",
                                style: cusPdctPageDisPriceStyle(
                                    getProportionateScreenHeight(26),
                                    Colors.black),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Rs. ${numFormat.format(meal.originalPrice ?? 0)}",
                                  style: hasDisPrice
                                      ? cusPdctOriPriceStyle(
                                          getProportionateScreenHeight(12))
                                      : cusPdctPageDisPriceStyle(
                                          getProportionateScreenHeight(24),
                                          kPrimaryColor),
                                ),
                                // sizedBoxOfWidth(8),
                                // Visibility(
                                //   visible: hasDisPrice,
                                //   child: Text(
                                //     "${_productOriPrice == null ? product.calculatePercentageDiscount() : discountPercent}% OFF",
                                //     // "20% OFF",
                                //     style: GoogleFonts.poppins(
                                //       textStyle: TextStyle(
                                //         color: Colors.red,
                                //         fontSize:
                                //             getProportionateScreenHeight(12),
                                //         fontWeight: FontWeight.w600,
                                //         letterSpacing:
                                //             getProportionateScreenHeight(0.5),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // sizedBoxOfWidth(12),
            Expanded(
              child: Container(
                height: getProportionateScreenHeight(80),
                child: FloatingActionButton.extended(
                  extendedPadding:
                      EdgeInsets.all(getProportionateScreenHeight(12)),
                  heroTag: "buyNow",
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    side: BorderSide(color: kPrimaryColor, width: 1),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutScreen(
                          selectedCartItems: [meal.id],
                          onCheckoutPressed:
                              selectedCheckoutButtonFromBuyNowCallback,
                          onCheckoutPressedForMeals:
                              selectedCheckoutButtonCallbackForMeals,
                          isBuyNow: true,
                          isMeal: true,
                        ),
                      ),
                    );
                  },
                  elevation: 0,
                  label: Text(
                    "Buy Now".toUpperCase(),
                    style: cusHeadingStyle(
                        fontSize: getProportionateScreenHeight(20),
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
