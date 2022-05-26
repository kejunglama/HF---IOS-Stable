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
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text("Swipe RIGHT to Delete", style: cusBodyStyle(getProportionateScreenHeight(12))),
                  // SizedBox(height: getProportionateScreenHeight(20)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.8,
                    child: Center(
                      child: buildCartItemsList(),
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

  Future<void> refreshPage() {
    cartItemsStream.reload();
    return Future<void>.value();
  }

  Widget buildCartItemsList() {
    return StreamBuilder<List<String>>(
      stream: cartItemsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> cartItemsId = snapshot.data;
          if (cartItemsId.length == 0) {
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
                  padding: EdgeInsets.symmetric(vertical: 16),
                  physics: BouncingScrollPhysics(),
                  itemCount: cartItemsId.length,
                  itemBuilder: (context, index) {
                    if (index >= cartItemsId.length) {
                      return SizedBox(height: getProportionateScreenHeight(80));
                    }
                    return buildSelectableCartItemDismissible(context, cartItemsId[index], index);
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
                  child: Text("Login to Continue", style: cusHeadingLinkStyle,),
                ),
              ),
              // NothingToShowContainer(
              //   iconPath: "assets/icons/network_error.svg",
              //   primaryMessage: "Something went wrong",
              //   secondaryMessage: "Unable to connect to Database",
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget buildCartItemDismissible(BuildContext context, String cartItemId, int index) {
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: buildCartItem(cartItemId, index),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
            context,
            "Remove Product from Cart?",
          );
          if (confirmation) {
            if (direction == DismissDirection.startToEnd) {
              bool result = false;
              String snackbarMessage;
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
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildSelectableCartItemDismissible(BuildContext context, String cartItemId, int index) {
    bool _isSelected = selectedCartItems.contains(cartItemId);
    return Dismissible(
      key: Key(cartItemId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: {
        DismissDirection.startToEnd: 0.65,
      },
      background: buildDismissibleBackground(),
      child: Row(
        children: [
          IconButton(
            icon:
                _isSelected ? Icon(Icons.check_box_rounded, color: kPrimaryColor) : Icon(Icons.check_box_outline_blank_rounded, color: kPrimaryColor),
            onPressed: () {
              setState(() {
                _isSelected ? selectedCartItems.remove(cartItemId) : selectedCartItems.add(cartItemId);
              });
            },
          ),
          Expanded(child: buildCartItem(cartItemId, index)),
        ],
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final confirmation = await showConfirmationDialog(
            context,
            "Remove Product from Cart?",
          );
          if (confirmation) {
            if (direction == DismissDirection.startToEnd) {
              bool result = false;
              String snackbarMessage;
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
        return false;
      },
      onDismissed: (direction) {},
    );
  }

  Widget buildCartItem(String cartItemId, int index) {
    Future<Product> pdct = ProductDatabaseHelper().getProductWithID(cartItemId);
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
            Product product = snapshot.data[0];

            int itemCount = 0;
            final cartItem = snapshot.data[1];
            if (cartItem.variation != null) {
              variation = cartItem.variation[0];
              // print(variation);
              itemCount = variation["item_count"];
            } else {
              itemCount = cartItem.itemCount;
            }
            // print(cartItem.variation);
            // print(product.id);

            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: ProductShortDetailCard(
                    productId: product.id,
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
                        SizedBox(height: 8),
                        Text(
                          "$itemCount",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 16,
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

  Future<void> checkoutButtonCallback(Map orderDetails) async {
    shutBottomSheet();
    // final confirmation = await showConfirmationDialog(
    //   context,
    //   "This is just a Project Testing App so, no actual Payment Interface is available.\nDo you want to proceed for Mock Ordering of Products?",
    // );
    // if (confirmation == false) {
    //   return;
    // }
    final orderFuture = UserDatabaseHelper().emptyCart();
    orderFuture.then((orderedProductsUid) async {
      if (orderedProductsUid != null) {
        // print(orderedProductsUid);
        final dateTime = DateTime.now();
        final formatedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
        // List<OrderedProduct> orderedProducts =
        // orderedProductsUid.map((e) => OrderedProduct(null, productUid: e, orderDate: formatedDateTime)).toList();
        List orderedProducts = [];
        for (var entry in orderedProductsUid.entries) {
          orderedProducts.add({
            OrderedProduct.PRODUCT_UID_KEY: entry.key,
            OrderedProduct.ITEM_COUNT_KEY: entry.value["item_count"],
          });
        }
        OrderedProduct order = OrderedProduct(null, products: orderedProducts, orderDate: formatedDateTime, orderDetails: orderDetails);
        print(order);

        // bool addedProductsToMyProducts = false;
        // String snackbarmMessage;
        // try {
        //   addedProductsToMyProducts = await UserDatabaseHelper().addToMyOrders(order);
        //   if (addedProductsToMyProducts) {
        //     snackbarmMessage = "Products ordered Successfully";
        //   } else {
        //     throw "Could not order products due to unknown issue";
        //   }
        // } on FirebaseException catch (e) {
        //   Logger().e(e.toString());
        //   snackbarmMessage = e.toString();
        // } catch (e) {
        //   Logger().e(e.toString());
        //   snackbarmMessage = e.toString();
        // } finally {
        //   Navigator.of(context).popUntil((route) => route.isFirst);
        //   // Navigator.push(
        //   //   context,
        //   //   MaterialPageRoute(
        //   //     builder: (context) => (home),
        //   //   ),
        //   // );
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(snackbarmMessage ?? "Something went wrong"),
        //     ),
        //   );
        // }
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

  Future<void> selectedCheckoutButtonCallback(Map orderDetails, List selectedProductsUid) async {
    shutBottomSheet();
    // final confirmation = await showConfirmationDialog(
    //   context,
    //   "This is just a Project Testing App so, no actual Payment Interface is available.\nDo you want to proceed for Mock Ordering of Products?",
    // );
    // if (confirmation == false) {
    //   return;
    // }
    final orderFuture = UserDatabaseHelper().emptySelectedCart(selectedProductsUid);
    orderFuture.then((orderedProductsUid) async {
      if (orderedProductsUid != null) {
        // print(orderedProductsUid);
        final dateTime = DateTime.now();
        final formatedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
        // List<OrderedProduct> orderedProducts =
        // orderedProductsUid.map((e) => OrderedProduct(null, productUid: e, orderDate: formatedDateTime)).toList();
        List orderedProducts = [];
        for (var entry in orderedProductsUid.entries) {
          orderedProducts.add({
            OrderedProduct.PRODUCT_UID_KEY: entry.key,
            OrderedProduct.ITEM_COUNT_KEY: entry.value["item_count"],
          });
        }
        OrderedProduct order = OrderedProduct(null, products: orderedProducts, orderDate: formatedDateTime, orderDetails: orderDetails);
        print(order);

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
              content: Text(snackbarmMessage ?? "Something went wrong"),
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
        );
      },
    );
  }
}
