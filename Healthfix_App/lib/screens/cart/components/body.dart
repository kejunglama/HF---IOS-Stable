import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_short_detail_card.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/CartItem.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/checkout/checkout_screen.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/screens/sign_in/sign_in_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/data_streams/cart_items_stream.dart';

import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:healthfix/wrappers/authentification_wrapper.dart';
import 'package:logger/logger.dart';

import '../../../utils.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final CartItemsStream cartItemsStream = CartItemsStream();
  List selectedCartItems = [];
  PersistentBottomSheetController bottomSheetHandler;
  Map variation = {};

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
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(screenPadding)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: AuthentificationService().currentUser != null ? buildCartItemsList() : buildLoginToContinue(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    cartItemsStream.reload();
    return Future<void>.value();
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<Map>>(
      stream: cartItemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          List<Map> cartItemsList = snapshot.data;
          // List cartItemsId = [];
          // cartandProductIds.forEach((_cartItem) {
          //   cartItemsId.add(_cartItem["var_id"] ?? _cartItem["product_id"]);
          // });
          // print("cartItemsId");
          // print(cartItemsId);

          if (cartItemsList.length == 0) {
            return Center(
              child: NothingToShowContainer(
                iconPath: "assets/icons/empty_cart.svg",
                secondaryMessage: "Your cart is empty",
              ),
            );
          }

          return Column(
            children: [
              // SizedBox(height: getProportionateScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(16)),
                  physics: BouncingScrollPhysics(),
                  itemCount: cartItemsList.length,
                  itemBuilder: (context, index) {
                    if (index >= cartItemsList.length) {
                      return SizedBox(height: getProportionateScreenHeight(80));
                    }
                    return buildSelectableCartItemDismissible(context, cartItemsList[index], index);
                  },
                ),
              ),
              DefaultButton(
                text: "Proceed to Checkout",
                press: () {
                  // bottomSheetHandler = Scaffold.of(context).showBottomSheet(
                  //   (context) {
                  //     return CheckoutCard(
                  //       onCheckoutPressed: checkoutButtonCallback,
                  //     );
                  //   },
                  // );
                  print(selectedCartItems);

                  String snackbarNotSelectedMessage = "Please Select a Item to Checkout";
                  selectedCartItems.isNotEmpty
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              selectedCartItems: selectedCartItems,
                              onCheckoutPressed: selectedCheckoutButtonCallback,
                            ),
                          ),
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(snackbarNotSelectedMessage),
                          ),
                        );
                  ;
                },
              ),
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
        return buildLoginToContinue();
      },
    );
  }

  Widget buildLoginToContinue() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
                );
              },
              child: Text(
                "Please Login to Continue",
                style: cusHeadingStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }

  // Widget buildCartItemDismissible(
  //     BuildContext context, String cartItemId, int index) {
  //   return Dismissible(
  //     key: Key(cartItemId),
  //     direction: DismissDirection.startToEnd,
  //     dismissThresholds: {
  //       DismissDirection.startToEnd: 0.65,
  //     },
  //     background: buildDismissibleBackground(),
  //     child: buildCartItem(cartItemId, index),
  //     confirmDismiss: (direction) async {
  //       if (direction == DismissDirection.startToEnd) {
  //         final confirmation = await showConfirmationDialog(
  //           context,
  //           "Remove Product from Cart?",
  //         );
  //         if (confirmation) {
  //           if (direction == DismissDirection.startToEnd) {
  //             bool result = false;
  //             String snackbarMessage;
  //             try {
  //               result = await UserDatabaseHelper()
  //                   .removeProductFromCart(cartItemId);
  //               if (result == true) {
  //                 snackbarMessage = "Product removed from cart successfully";
  //                 await refreshPage();
  //               } else {
  //                 throw "Coulnd't remove product from cart due to unknown reason";
  //               }
  //             } on FirebaseException catch (e) {
  //               Logger().w("Firebase Exception: $e");
  //               snackbarMessage = "Something went wrong";
  //             } catch (e) {
  //               Logger().w("Unknown Exception: $e");
  //               snackbarMessage = "Something went wrong";
  //             } finally {
  //               Logger().i(snackbarMessage);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Text(snackbarMessage),
  //                 ),
  //               );
  //             }

  //             return result;
  //           }
  //         }
  //       }
  //       return false;
  //     },
  //     onDismissed: (direction) {},
  //   );
  // }

  buildConfirmationToDelete(DismissDirection direction, cartItemId) async {
    final confirmation = await showConfirmationDialog(
      context,
      "Remove Product from Cart?",
      positiveResponse: "Remove",
      negativeResponse: "Cancel",
    );
    if (confirmation) {
      if (direction == DismissDirection.startToEnd) {
        bool result = false;
        String snackbarMessage;
        print("cartItemId");
        print(cartItemId);
        try {
          result = await UserDatabaseHelper().removeProductFromCart(cartItemId);
          if (result == true) {
            snackbarMessage = "Product removed from cart successfully";
            await refreshPage();
          } else {
            throw "Coulnd't remove product from cart due to unknown reason";
          }
        } on FirebaseException catch (e) {
          Logger().w("Firebase Exception: $e");
          snackbarMessage = "Something went wrong";
        } catch (e) {
          Logger().w("Unknown Exception: $e");
          snackbarMessage = "Something went wrong";
        } finally {
          Logger().i(snackbarMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarMessage),
            ),
          );
        }
        return result;
      }
    }
  }

  Widget buildSelectableCartItemDismissible(BuildContext context, Map cartItemIdMap, int index) {
    bool _isSelected = selectedCartItems.contains(cartItemIdMap);
    String cartItemPdctId = cartItemIdMap["product_id"] ?? cartItemIdMap["var_id"];
    String cartItemId = cartItemIdMap["var_id"] ?? cartItemIdMap["product_id"];
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: InkWell(
        onLongPress: () {
          buildConfirmationToDelete(DismissDirection.startToEnd, cartItemId);
        },
        child: Row(
          children: [
            IconButton(
              icon: _isSelected
                  ? Icon(Icons.check_box_rounded, color: kPrimaryColor)
                  : Icon(Icons.check_box_outline_blank_rounded, color: kPrimaryColor),
              onPressed: () {
                setState(() {
                  _isSelected ? selectedCartItems.remove(cartItemIdMap) : selectedCartItems.add(cartItemIdMap);
                });
                // print(selectedCartItems);
              },
            ),
            Expanded(child: buildCartItem(cartItemIdMap, cartItemId, cartItemPdctId, index)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          buildConfirmationToDelete(DismissDirection.startToEnd, cartItemId);

          // final confirmation = await showConfirmationDialog(
          //   context,
          //   "Remove Product from Cart?",
          // );
          // if (confirmation) {
          //   if (direction == DismissDirection.startToEnd) {
          //     bool result = false;
          //     String snackbarMessage;
          //     try {
          //       result = await UserDatabaseHelper()
          //           .removeProductFromCart(cartItemId);
          //       if (result == true) {
          //         snackbarMessage = "Product removed from cart successfully";
          //         await refreshPage();
          //       } else {
          //         throw "Coulnd't remove product from cart due to unknown reason";
          //       }
          //     } on FirebaseException catch (e) {
          //       Logger().w("Firebase Exception: $e");
          //       snackbarMessage = "Something went wrong";
          //     } catch (e) {
          //       Logger().w("Unknown Exception: $e");
          //       snackbarMessage = "Something went wrong";
          //     } finally {
          //       Logger().i(snackbarMessage);
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(snackbarMessage),
          //         ),
          //       );
          //     }
          //     return result;
          //   }
          // }
        }
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildCartItem(Map cartItemMap, String cartItemId, String cartItemPdctId, int index) {
    Future<Product> pdct = ProductDatabaseHelper().getProductWithID(cartItemPdctId);
    Future<CartItem> cartItem = UserDatabaseHelper().getCartItemFromId(cartItemId);

    return Container(
      padding: EdgeInsets.only(
        bottom: 4,
        top: 4,
        right: 4,
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: kTextColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FutureBuilder(
        // future: ProductDatabaseHelper().getProductWithID(cartItemId),
        future: Future.wait([pdct, cartItem]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            // Product product = snapshot.data[0];
            CartItem cartItem = snapshot.data[1];

            int itemCount = 0;
            // if (cartItem.variation != null) {
            // variation = cartItem.variation;
            itemCount = cartItem.itemCount;
            // print(variation);
            // print(itemCount);
            //   itemCount = variation["item_count"];
            // } else {
            // }
            // print(cartItem.variation);
            // print(product.id);

            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: ProductShortDetailCard(
                    productId: cartItem.productId ?? cartItem.id,
                    variantId: cartItem.id,
                    // variation: variation,
                    buildConfirmationToDelete: buildConfirmationToDelete,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            productId: cartItemPdctId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: Container(
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: 2,
                    //   vertical: 12,
                    // ),
                    decoration: BoxDecoration(
                      // color: kTextColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_drop_up,
                            color: kPrimaryColor,
                          ),
                          onTap: () async {
                            await arrowUpCallback(cartItemId);
                          },
                        ),
                        sizedBoxOfHeight(8),
                        Text(
                          "$itemCount",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: getProportionateScreenHeight(16),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          child: itemCount > 1
                              ? Icon(
                                  Icons.arrow_drop_down,
                                  color: kPrimaryColor,
                                )
                              : Icon(
                                  Icons.arrow_drop_down,
                                  color: kPrimaryColor.withOpacity(0.3),
                                ),
                          onTap: () async {
                            if (itemCount > 1) await arrowDownCallback(cartItemId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget buildDismissibleBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectedCheckoutButtonCallback(Map orderDetails, List selectedCartItems, {bool isBuyNow}) async {
    shutBottomSheet();
    // final confirmation = await showConfirmationDialog(
    //   context,
    //   "This is just a Project Testing App so, no actual Payment Interface is available.\nDo you want to proceed for Mock Ordering of Products?",
    // );
    // if (confirmation == false) {
    //   return;
    // }
    List selectedCartItemsIds = [];
    selectedCartItems.forEach((cartItem) {
      selectedCartItemsIds.add(cartItem["var_id"] ?? cartItem["product_id"]);
    });
    print("hellooooo");
    print(selectedCartItemsIds);

    final orderFuture = UserDatabaseHelper().emptySelectedCart(selectedCartItemsIds);
    orderFuture.then((orderedProductsUid) async {
      if (orderedProductsUid != null) {
        print("orderedProductsUid");
        print(orderedProductsUid);

        final formatedDateTime = DateTime.now();
        // final dateTime = DateTime.now();
        // List<OrderedProduct> orderedProducts =
        // orderedProductsUid.map((e) => OrderedProduct(null, productUid: e, orderDate: formatedDateTime)).toList();
        List orderedProducts = [];
        for (var entry in orderedProductsUid.entries) {
          Map orderedProduct = {};
          print("entry");
          print(entry.key);

          if (entry.value["product_id"] != null) {
            orderedProduct[OrderedProduct.PRODUCT_UID_KEY] = entry.value["product_id"];
            orderedProduct[OrderedProduct.VARIATION_UID_KEY] = entry.key;
          } else {
            orderedProduct[OrderedProduct.PRODUCT_UID_KEY] = entry.key;
          }

          // orderedProduct[OrderedProduct.PRODUCT_UID_KEY] =
          //     entry.value["product_id"] ?? entry.key;
          // if (entry.value["var_id"] == null)
          //   orderedProduct[OrderedProduct.VARIATION_UID_KEY] = entry.key;
          orderedProduct[OrderedProduct.ITEM_COUNT_KEY] = entry.value["item_count"];
          print("orderedProduct");
          print(orderedProduct);
          orderedProducts.add(orderedProduct);
        }
        OrderedProduct order = OrderedProduct(
          null,
          products: orderedProducts,
          orderDate: formatedDateTime,
          orderDetails: orderDetails,
        );
        // print(order);

        bool addedProductsToMyProducts = false;
        String snackbarmMessage;
        try {
          addedProductsToMyProducts = await UserDatabaseHelper().addToMyOrders(order);
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => (home),
          //   ),
          // );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                snackbarmMessage ?? "Something went wrong",
                style: TextStyle(fontSize: getProportionateScreenHeight(16)),
              ),
            ),
          );
        }
      } else {
        throw "Something went wrong while clearing cart";
      }
      await showDialog(
        context: context,
        builder: (context) {
          return FutureProgressDialog(
            orderFuture,
            message: Text("Placing the Order"),
          );
        },
      );
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    });
    await showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          orderFuture,
          message: Text("Placing the Order"),
        );
      },
    );
    await refreshPage();
  }

  void shutBottomSheet() {
    if (bottomSheetHandler != null) {
      bottomSheetHandler.close();
    }
  }

  Future<void> arrowUpCallback(String cartItemId) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().increaseCartItemCount(cartItemId, variation);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          future,
          message: Text("Please wait"),
        );
      },
    );
  }

  Future<void> arrowDownCallback(String cartItemId) async {
    shutBottomSheet();
    final future = UserDatabaseHelper().decreaseCartItemCount(cartItemId);
    future.then((status) async {
      if (status) {
        await refreshPage();
      } else {
        throw "Couldn't perform the operation due to some unknown issue";
      }
    }).catchError((e) {
      Logger().e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    });
    await showDialog(
      context: context,
      builder: (context) {
        return FutureProgressDialog(
          future,
          message: Text("Please wait"),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(getProportionateScreenHeight(5)),
          ),
        );
      },
    );
  }
}
