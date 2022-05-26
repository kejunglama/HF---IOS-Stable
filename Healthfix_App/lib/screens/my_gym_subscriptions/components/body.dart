import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_short_detail_card.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/models/Review.dart';
import 'package:healthfix/models/gymSubscription.dart';
import 'package:healthfix/screens/my_gym_subscription_details/my_gym_subscriptions_detail_screen.dart';
import 'package:healthfix/screens/my_orders/components/product_review_dialog.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/data_streams/gym_subscriptions_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';
import 'package:pretty_json/pretty_json.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GymSubscriptionsStream gymSubscriptionsStream = GymSubscriptionsStream();

  @override
  void initState() {
    super.initState();
    gymSubscriptionsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    gymSubscriptionsStream.dispose();
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
                  // SizedBox(height: getProportionateScreenHeight(10)),
                  // Text(
                  //   "Your Gym Subscriptions",
                  //   style: headingStyle,
                  // ),
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
    gymSubscriptionsStream.reload();
    return Future<void>.value();
  }

  Widget buildOrderedList() {
    return StreamBuilder<List<String>>(
      stream: gymSubscriptionsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final gymSubscriptionsIds = snapshot.data;
          if (gymSubscriptionsIds.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: gymSubscriptionsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: UserDatabaseHelper().getGymSubscriptionFromId(gymSubscriptionsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final gymSubscription = snapshot.data;
                    // print(gymSubscription);
                    // print(prettyJson(gymSubscription.toMap(), indent: 2));
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GymSubscriptionDetails(gymSubscription),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: getProportionateScreenHeight(40),
                                  width: getProportionateScreenHeight(40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: kPrimaryColor.withOpacity(0.12),
                                  ),
                                  child: Icon(
                                    Icons.fitness_center_rounded,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                sizedBoxOfWidth(16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${gymSubscription.gymName}",
                                        style: cusHeadingStyle(16, Colors.black.withOpacity(0.7)),
                                      ),
                                      // sizedBoxOfHeight(8),
                                      Text(
                                        "Starts From: ${gymSubscription.startingFrom}",
                                        style: cusBodyStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${currency.format(gymSubscription.package["price"])}",
                                        style: cusHeadingStyle(16, Colors.black.withOpacity(0.7)),
                                      ),
                                      Text(
                                        "${gymSubscription.package["duration"]}",
                                        style: cusBodyStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider( color: Colors.black12),
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

  Widget buildGymSubscriptionsList() {
    return StreamBuilder<List<String>>(
      stream: gymSubscriptionsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final gymSubscriptionsIds = snapshot.data;
          if (gymSubscriptionsIds.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_bag.svg",
                secondaryMessage: "Order something to show here",
              ),
            );
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: gymSubscriptionsIds.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: UserDatabaseHelper().getGymSubscriptionFromId(gymSubscriptionsIds[index]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final gymSubscription = snapshot.data;
                    // print(gymSubscription);
                    print(prettyJson(gymSubscription.toMap(), indent: 2));
                    return buildGymSubscriptionItem(gymSubscription);
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

  Widget buildGymSubscriptionItem(GymSubscription gymSubscription) {
    return FutureBuilder<Product>(
      future: ProductDatabaseHelper().getProductWithID(gymSubscription.id),
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
                          text: gymSubscription.startingFrom,
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
// Widget buildgymSubscriptionItem(gymSubscription gymSubscription) {
//   return FutureBuilder<Product>(
//     future: ProductDatabaseHelper().getProductWithID(gymSubscription.productUid),
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
//                         text: gymSubscription.orderDate,
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
