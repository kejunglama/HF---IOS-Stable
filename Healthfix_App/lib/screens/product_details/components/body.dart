import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthfix/components/rounded_icon_button.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/cart/cart_screen.dart';
import 'package:healthfix/screens/checkout/checkout_screen.dart';
import 'package:healthfix/screens/product_details/components/product_actions_section.dart';
import 'package:healthfix/screens/product_details/components/product_images.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/shared_preference.dart';
import 'package:healthfix/size_config.dart';
import 'package:healthfix/wrappers/authentification_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'fab_add_to_cart.dart';
import 'fab_buy_now.dart';

class Body extends StatefulWidget {
  final String productId;

  Body({Key key, @required this.productId}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  num _productDisPrice, _productOriPrice;
  Product product;
  Map _selectedColor;
  String _selectedSize;
  Map selectedVariations;
  var numFormat = NumberFormat('#,##,000');

  @override
  void initState() {
    super.initState();
  }

  void setSelectedVariant(String size, Map color) {
    _selectedColor = color;
    _selectedSize = size;

    List variant = product.variations
        .where((variant) => variant["size"] == _selectedSize)
        .where((variant) => variant["color"]["name"] == _selectedColor["name"])
        .toList();

    setState(() {
      _productDisPrice = int.parse(variant.first["price"]);
      _productOriPrice = 1.2 * _productDisPrice;
    });
  }

  Map onCartTapFetchVariant() {
    if (product.variations != null) {
      if (_selectedSize == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select a Size"),
          ),
        );
      } else if (_selectedColor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select a Color"),
          ),
        );
      } else {
        selectedVariations = {"size": _selectedSize, "color": _selectedColor};
        // print(selectedVariations);
      }
    } else {
      selectedVariations = {};
    }
    return selectedVariations;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Product>(
          future: ProductDatabaseHelper().getProductWithID(widget.productId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              product = snapshot.data;
              if (_productDisPrice == null) {
                _productDisPrice = product.discountPrice;
                _productOriPrice = 1.2 * _productDisPrice;
              }
              return Stack(
                children: [
                  Scaffold(
                    body: SafeArea(
                      child: SingleChildScrollView(
                        // physics: BouncingScrollPhysics(),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RoundedIconButton(
                                      iconData: Icons.arrow_back_ios_rounded,
                                      press: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SizedBox(width: getProportionateScreenWidth(15)),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.zero,
                                        alignment: Alignment.centerLeft,
                                        height: getProportionateScreenHeight(30),
                                        child: Image.asset('assets/logo/HF-logo.png'),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: getProportionateScreenWidth(8)),
                                          child: Icon(
                                            Icons.search_rounded,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => CartScreen()),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(right: getProportionateScreenWidth(8)),
                                            child: Icon(
                                              Icons.shopping_bag,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ProductImages(product: product),
                              ProductActionsSection(product: product, setSelectedVariant: setSelectedVariant),
                              SizedBox(height: getProportionateScreenHeight(80)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomProductBar(),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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
      ],
    );
  }

  Positioned bottomProductBar() {
    UserPreferences prefs = new UserPreferences();

    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        height: getProportionateScreenHeight(70),
        width: SizeConfig.screenWidth,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: getProportionateScreenHeight(60),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Rs. ${numFormat.format(_productDisPrice)}  ",
                        style: cusPdctPageDisPriceStyle(getProportionateScreenWidth(26), Colors.black),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rs. ${numFormat.format(_productOriPrice)}",
                            style: cusPdctOriPriceStyle(getProportionateScreenWidth(12)),
                          ),
                          sizedBoxOfWidth(8),
                          Text(
                            // "${product.calculatePercentageDiscount()}% OFF",
                            "20% OFF",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.w600,
                                letterSpacing: getProportionateScreenWidth(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AddToCartFAB(
              productId: product.id,
              onTap: () {
                prefs.hasUser().then((hasUser) => hasUser
                    ? onCartTapFetchVariant
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthenticationWrapper(),
                        )));
              },
            ),
            sizedBoxOfWidth(12),
            BuyNowFAB(
              productId: product.id,
              onTap: () {
                prefs.hasUser().then((hasUser) => hasUser
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            selectedCartItems: [product.id],
                            onCheckoutPressed: selectedCheckoutButtonFromBuyNowCallback,
                            isBuyNow: true,
                          ),
                        ),
                      )
                    : Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
                      ));
              },
            ),
          ],
        ),
      ),
    );
  }

  setVariantPrices(num disPrice, num oriPrice) {
    setState(() {
      _productDisPrice = disPrice;
      _productOriPrice = oriPrice;
    });
  }

  Future<void> selectedCheckoutButtonFromBuyNowCallback(Map orderDetails, List selectedProductsUid) async {
    if (selectedProductsUid != null) {
      // print(orderedProductsUid);
      final dateTime = DateTime.now();
      final formatedDateTime = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      List orderedProducts = [];
      orderedProducts.add({
        OrderedProduct.PRODUCT_UID_KEY: selectedProductsUid[0],
        OrderedProduct.ITEM_COUNT_KEY: 1,
      });
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarmMessage ?? "Something went wrong"),
          ),
        );
      }
    }
  }
}
