import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/components/product_short_detail_card.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/models/Review.dart';
import 'package:healthfix/screens/my_orders/components/product_review_dialog.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class OrderDetails extends StatelessWidget {
  OrderedProduct orderedProduct;

  OrderDetails({this.orderedProduct});

  @override
  Widget build(BuildContext context) {
    var currency = new NumberFormat.currency(locale: "en_US", symbol: "Rs. ", decimalDigits: 0);
    // print(orderedProduct.products);
    orderedProduct.products.forEach((e) => buildOrderedProductItem(e));
    var orderDetails = orderedProduct.orderDetails;
    var orderDetailsAddress = orderDetails["address"];
    var orderDetailsTotals = orderDetails["totals"];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "Order Details",
                    style: headingStyle,
                  ),
                  Text(
                    orderedProduct.id,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  // Text(orderedProduct.orderDetails.toString()),
                  buildOrderDetails(orderDetailsAddress, currency, orderDetailsTotals),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: Column(
                      children: [for (var e in orderedProduct.products) buildOrderedProductItem(e)],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildOrderDetails(orderDetailsAddress, NumberFormat currency, orderDetailsTotals) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Receiver: ${orderDetailsAddress["receiver"]}"),
              Text("Phone: ${orderDetailsAddress["phone"]}"),
              Text("Address: ${orderDetailsAddress["landmark"]}, ${orderDetailsAddress["address_line_1"]}"),
              Text("Email: ${orderDetailsAddress["email"]}"),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Cart Total: ${currency.format(orderDetailsTotals["cartTotal"])}"),
              Text("Delivery Charge: ${currency.format(orderDetailsTotals["deliveryCharge"])}"),
              Text("Net Total: ${currency.format(orderDetailsTotals["netTotal"])}"),
            ],
          )
        ],
      ),
    );
  }

  // Widget buildOrderedProductsList() {
  //   return StreamBuilder<List<String>>(
  //     stream: orderedProductsStream.stream,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         final orderedProductsIds = snapshot.data;
  //         if (orderedProductsIds.length == 0) {
  //           return Center(
  //             child: NothingToShowContainer(
  //               iconPath: "assets/icons/empty_bag.svg",
  //               secondaryMessage: "Order something to show here",
  //             ),
  //           );
  //         }
  //         return ListView.builder(
  //           physics: BouncingScrollPhysics(),
  //           itemCount: orderedProductsIds.length,
  //           itemBuilder: (context, index) {
  //             return FutureBuilder<OrderedProduct>(
  //               future: UserDatabaseHelper().getOrderedProductFromId(orderedProductsIds[index]),
  //               builder: (context, snapshot) {
  //                 if (snapshot.hasData) {
  //                   final orderedProduct = snapshot.data;
  //                   // print(orderedProduct);
  //                   print(prettyJson(orderedProduct.toMap(), indent: 2));
  //                   return buildOrderedProductItem(orderedProduct);
  //                 } else if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return Center(child: CircularProgressIndicator());
  //                 } else if (snapshot.hasError) {
  //                   final error = snapshot.error.toString();
  //                   Logger().e(error);
  //                 }
  //                 return Icon(
  //                   Icons.error,
  //                   size: 60,
  //                   color: kTextColor,
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       } else if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else if (snapshot.hasError) {
  //         final error = snapshot.error;
  //         Logger().w(error.toString());
  //       }
  //       return Center(
  //         child: NothingToShowContainer(
  //           iconPath: "assets/icons/network_error.svg",
  //           primaryMessage: "Something went wrong",
  //           secondaryMessage: "Unable to connect to Database",
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  Widget buildOrderedProductItem(Map products) {
    print(products["item_count"]);
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(products["product_uid"]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data;
          // print(i++);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 4,
                  //   vertical: 8,
                  // ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: kTextColor.withOpacity(0.15),
                      ),
                      horizontal: BorderSide(
                        color: kTextColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      ProductShortDetailCard(
                        productId: product.id,
                        itemCount: products["item_count"],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                productId: product.id,
                              ),
                            ),
                          ).then((_) async {
                            // await refreshPage();
                          });
                        },
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FlatButton(
                          onPressed: () async {
                            String currentUserUid = AuthentificationService().currentUser.uid;
                            Review prevReview;
                            try {
                              prevReview = await ProductDatabaseHelper().getProductReviewWithID(product.id, currentUserUid);
                            } on FirebaseException catch (e) {
                              Logger().w("Firebase Exception: $e");
                            } catch (e) {
                              Logger().w("Unknown Exception: $e");
                            } finally {
                              if (prevReview == null) {
                                prevReview = Review(
                                  currentUserUid,
                                  reviewerUid: currentUserUid,
                                );
                              }
                            }

                            final result = await showDialog(
                              context: context,
                              builder: (context) {
                                return ProductReviewDialog(
                                  review: prevReview,
                                );
                              },
                            );
                            if (result is Review) {
                              bool reviewAdded = false;
                              String snackbarMessage;
                              try {
                                reviewAdded = await ProductDatabaseHelper().addProductReview(product.id, result);
                                if (reviewAdded == true) {
                                  snackbarMessage = "Product review added successfully";
                                } else {
                                  throw "Coulnd't add product review due to unknown reason";
                                }
                              } on FirebaseException catch (e) {
                                Logger().w("Firebase Exception: $e");
                                snackbarMessage = e.toString();
                              } catch (e) {
                                Logger().w("Unknown Exception: $e");
                                snackbarMessage = e.toString();
                              } finally {
                                Logger().i(snackbarMessage);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(snackbarMessage),
                                  ),
                                );
                              }
                            }
                            // await refreshPage();
                          },
                          child: Text(
                            "Give Product Review",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          final error = snapshot.error.toString();
          Logger().e(error);
        }
        return Icon(
          Icons.error,
          size: 60,
          color: kTextColor,
        );
      },
    );
  }
}
