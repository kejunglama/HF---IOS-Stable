import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_short_detail_card.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/models/Review.dart';
import 'package:healthfix/screens/my_orders/components/product_review_dialog.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/data_streams/ordered_products_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';
import 'package:pretty_json/pretty_json.dart';

import 'order_details_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final OrderedProductsStream orderedProductsStream = OrderedProductsStream();

  @override
  void initState() {
    super.initState();
    orderedProductsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    orderedProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "Your Orders",
                    style: headingStyle,
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.75,
                    child: buildOrderedList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    orderedProductsStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderedList() {
    return StreamBuilder<List<String>>(
      stream: orderedProductsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderedProductsIds = snapshot.data;
          if (orderedProductsIds.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orderedProductsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<OrderedProduct>(
                future: UserDatabaseHelper().getOrderedProductFromId(orderedProductsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data;
                    // print(orderedProduct);
                    // print(prettyJson(orderedProduct.toMap(), indent: 2));
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetails(orderedProduct: orderedProduct),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order ID: ${orderedProduct.id}",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text("Ordered on: ${orderedProduct.orderDate}"),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,size: getProportionateScreenHeight(20),
                                    color: kPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 4,
                          //     vertical: 8,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.symmetric(
                          //       vertical: BorderSide(
                          //         color: kTextColor.withOpacity(0.15),
                          //       ),
                          //     ),
                          //   ),
                          //
                          // ),
                          // Container(
                          //   width: double.infinity,
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: 8,
                          //     vertical: 2,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     color: kPrimaryColor,
                          //     borderRadius: BorderRadius.only(
                          //       bottomLeft: Radius.circular(16),
                          //       bottomRight: Radius.circular(16),
                          //     ),
                          //   ),
                          //   child: FlatButton(
                          //     onPressed: () async {
                          //       String currentUserUid = AuthentificationService().currentUser.uid;
                          //       Review prevReview;
                          //       try {
                          //         prevReview = await ProductDatabaseHelper().getProductReviewWithID(product.id, currentUserUid);
                          //       } on FirebaseException catch (e) {
                          //         Logger().w("Firebase Exception: $e");
                          //       } catch (e) {
                          //         Logger().w("Unknown Exception: $e");
                          //       } finally {
                          //         if (prevReview == null) {
                          //           prevReview = Review(
                          //             currentUserUid,
                          //             reviewerUid: currentUserUid,
                          //           );
                          //         }
                          //       }
                          //
                          //       final result = await showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return ProductReviewDialog(
                          //             review: prevReview,
                          //           );
                          //         },
                          //       );
                          //       if (result is Review) {
                          //         bool reviewAdded = false;
                          //         String snackbarMessage;
                          //         try {
                          //           reviewAdded = await ProductDatabaseHelper().addProductReview(product.id, result);
                          //           if (reviewAdded == true) {
                          //             snackbarMessage = "Product review added successfully";
                          //           } else {
                          //             throw "Coulnd't add product review due to unknown reason";
                          //           }
                          //         } on FirebaseException catch (e) {
                          //           Logger().w("Firebase Exception: $e");
                          //           snackbarMessage = e.toString();
                          //         } catch (e) {
                          //           Logger().w("Unknown Exception: $e");
                          //           snackbarMessage = e.toString();
                          //         } finally {
                          //           Logger().i(snackbarMessage);
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content: Text(snackbarMessage),
                          //             ),
                          //           );
                          //         }
                          //       }
                          //       await refreshPage();
                          //     },
                          //     child: Text(
                          //       "Give Product Review",
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w600,
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
            },
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

  Widget buildOrderedProductsList() {
    return StreamBuilder<List<String>>(
      stream: orderedProductsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orderedProductsIds = snapshot.data;
          if (orderedProductsIds.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: orderedProductsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder<OrderedProduct>(
                future: UserDatabaseHelper().getOrderedProductFromId(orderedProductsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orderedProduct = snapshot.data;
                    // print(orderedProduct);
                    print(prettyJson(orderedProduct.toMap(), indent: 2));
                    return buildOrderedProductItem(orderedProduct);
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
            },
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

  Widget buildOrderedProductItem(OrderedProduct orderedProduct) {
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(orderedProduct.productUid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kTextColor.withOpacity(0.12),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Ordered on:  ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: orderedProduct.orderDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(
                        color: kTextColor.withOpacity(0.15),
                      ),
                    ),
                  ),
                  child: ProductShortDetailCard(
                    productId: product.id,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: product.id,
                          ),
                        ),
                      ).then((_) async {
                        await refreshPage();
                      });
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
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
                      await refreshPage();
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
// Widget buildOrderedProductItem(OrderedProduct orderedProduct) {
//   return FutureBuilder<Product>(
//     future: ProductDatabaseHelper().getProductWithID(orderedProduct.productUid),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         final product = snapshot.data;
//         return Padding(
//           padding: EdgeInsets.symmetric(vertical: 6),
//           child: Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 16,
//                 ),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: kTextColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: Text.rich(
//                   TextSpan(
//                     text: "Ordered on:  ",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                     ),
//                     children: [
//                       TextSpan(
//                         text: orderedProduct.orderDate,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 4,
//                   vertical: 8,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.symmetric(
//                     vertical: BorderSide(
//                       color: kTextColor.withOpacity(0.15),
//                     ),
//                   ),
//                 ),
//                 child: ProductShortDetailCard(
//                   productId: product.id,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductDetailsScreen(
//                           productId: product.id,
//                         ),
//                       ),
//                     ).then((_) async {
//                       await refreshPage();
//                     });
//                   },
//                 ),
//               ),
//               Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 8,
//                   vertical: 2,
//                 ),
//                 decoration: BoxDecoration(
//                   color: kPrimaryColor,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(16),
//                     bottomRight: Radius.circular(16),
//                   ),
//                 ),
//                 child: FlatButton(
//                   onPressed: () async {
//                     String currentUserUid = AuthentificationService().currentUser.uid;
//                     Review prevReview;
//                     try {
//                       prevReview = await ProductDatabaseHelper().getProductReviewWithID(product.id, currentUserUid);
//                     } on FirebaseException catch (e) {
//                       Logger().w("Firebase Exception: $e");
//                     } catch (e) {
//                       Logger().w("Unknown Exception: $e");
//                     } finally {
//                       if (prevReview == null) {
//                         prevReview = Review(
//                           currentUserUid,
//                           reviewerUid: currentUserUid,
//                         );
//                       }
//                     }
//
//                     final result = await showDialog(
//                       context: context,
//                       builder: (context) {
//                         return ProductReviewDialog(
//                           review: prevReview,
//                         );
//                       },
//                     );
//                     if (result is Review) {
//                       bool reviewAdded = false;
//                       String snackbarMessage;
//                       try {
//                         reviewAdded = await ProductDatabaseHelper().addProductReview(product.id, result);
//                         if (reviewAdded == true) {
//                           snackbarMessage = "Product review added successfully";
//                         } else {
//                           throw "Coulnd't add product review due to unknown reason";
//                         }
//                       } on FirebaseException catch (e) {
//                         Logger().w("Firebase Exception: $e");
//                         snackbarMessage = e.toString();
//                       } catch (e) {
//                         Logger().w("Unknown Exception: $e");
//                         snackbarMessage = e.toString();
//                       } finally {
//                         Logger().i(snackbarMessage);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(snackbarMessage),
//                           ),
//                         );
//                       }
//                     }
//                     await refreshPage();
//                   },
//                   child: Text(
//                     "Give Product Review",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       } else if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(child: CircularProgressIndicator());
//       } else if (snapshot.hasError) {
//         final error = snapshot.error.toString();
//         Logger().e(error);
//       }
//       return Icon(
//         Icons.error,
//         size: 60,
//         color: kTextColor,
//       );
//     },
//   );
// }
}
