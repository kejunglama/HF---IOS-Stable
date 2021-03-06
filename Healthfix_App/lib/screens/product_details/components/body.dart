import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:healthfix/app.dart';
// import 'package:healthfix/components/rounded_icon_button.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/models/CartItem.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/cart/cart_screen.dart';
import 'package:healthfix/screens/category_products/category_products_screen.dart';
import 'package:healthfix/screens/checkout/checkout_screen.dart';
import 'package:healthfix/screens/product_details/components/product_actions_section.dart';
import 'package:healthfix/screens/product_details/components/product_images.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
// import 'package:healthfix/screens/search/search_screen.dart';
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
  num _productDisPrice, _productOriPrice, discountPercent;
  Product product;
  Map _selectedColor;
  String _selectedSize;
  String seletedVarId;
  Map selectedVariations;
  bool _selected = false;
  var _variantId;
  var numFormat = NumberFormat('#,##,000');

  @override
  void initState() {
    super.initState();
  }

  void setSelectedVariant(String size, Map color) {
    _selectedColor = color;
    _selectedSize = size;
    List variant;
    if (_selectedColor != null && _selectedSize != null) {
      variant = product.variations
          .where((variant) => (variant["size"] == _selectedSize))
          .where((variant) => variant["color"]["name"] == _selectedColor["name"])
          .toList();
    } else if (_selectedColor == null) {
      variant = product.variations.where((variant) => (variant["size"] == _selectedSize)).toList();
    } else if (_selectedSize == null) {
      variant = product.variations.where((variant) => variant["color"]["name"] == _selectedColor["name"]).toList();
    }

    setState(() {
      _productDisPrice = variant.first["price"];
      _productOriPrice = variant.first["dis_price"] ?? (1.2 * _productDisPrice).toInt();
      discountPercent = ((_productOriPrice - _productDisPrice) * 100 / _productOriPrice).round();
      _selected = true;
    });
    // print(
    //     "from color is set to $_selectedColor $_productDisPrice $_productOriPrice ${discountPercent.round()}");
  }

  String getSeletedVariantId() {
    if (product.variations != null) {
      bool hasSizeVariation = product.variations.first["size"] != null;
      bool hasColorVariation = product.variations.first["color"] != null;
      if (_selectedSize == null && hasSizeVariation) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select a Size"),
          ),
        );
      } else if (_selectedColor == null && hasColorVariation) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Select a Color"),
          ),
        );
      } else {
        seletedVarId = product.variations
            .where((variant) => ((hasSizeVariation ? variant["size"] == _selectedSize : true) &&
                (hasColorVariation ? variant["color"]["hex"] == _selectedColor["hex"] : true)))
            .first["var_id"];
        // print(seletedVarId);
        // selectedVariations = {"size": _selectedSize, "color": _selectedColor};
        // print(selectedVariations);
      }
    } else {
      seletedVarId = null;
    }
    return seletedVarId;
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
                _productOriPrice = product.originalPrice;
              }

              if (_productDisPrice == null) {
                _productDisPrice = product.discountPrice;
              }
              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: Colors.transparent,

                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      systemOverlayStyle: SystemUiOverlayStyle(
                        // Status bar color
                        statusBarColor: Colors.teal,
                        // Status bar brightness (optional)
                        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
                        statusBarBrightness: Brightness.light, // For iOS (dark icons)
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  productType: ProductType.All,
                                  productTypes: pdctCategories,
                                  subProductType: "",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: getProportionateScreenWidth(8)),
                            child: Icon(Icons.search),
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
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // appBar: AppBar(
                    //   // backgroundColor: Colors.transparent,
                    //   title: Container(
                    //     margin: EdgeInsets.zero,
                    //     alignment: Alignment.center,
                    //     height: getProportionateScreenHeight(30),
                    //     child: Image.asset('assets/logo/HF-logo.png'),
                    //   ),
                    //   actions: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => CategoryProductsScreen(
                    //               productType: ProductType.All,
                    //               productTypes: pdctCategories,
                    //               subProductType: "",
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //       child: Container(
                    //         margin: EdgeInsets.only(
                    //             right: getProportionateScreenWidth(8)),
                    //         child: SvgPicture.asset(
                    //           "assets/icons/Search Icon.svg",
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => CartScreen()),
                    //         );
                    //       },
                    //       child: Container(
                    //         margin: EdgeInsets.only(
                    //             right: getProportionateScreenWidth(8)),
                    //         child: SvgPicture.asset(
                    //           "assets/icons/Cart Icon.svg",
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    body: Container(
                      color: Colors.white,
                      // color: Color(0xFFF8F8F8),

                      child: Column(
                        children: [
                          // SizedBox(
                          //   height: getProportionateScreenHeight(50),
                          //   child: Row(
                          //     mainAxisAlignment:
                          //         MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       RoundedIconButton(
                          //         iconData: Icons.arrow_back_ios_rounded,
                          //         press: () {
                          //           Navigator.pop(context);
                          //         },
                          //       ),
                          //       SizedBox(
                          //           width: getProportionateScreenWidth(15)),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.zero,
                          //           alignment: Alignment.centerLeft,
                          //           height: getProportionateScreenHeight(30),
                          //           child: Image.asset(
                          //               'assets/logo/HF-logo.png'),
                          //         ),
                          //       ),
                          //       Row(
                          //         children: [
                          //           Container(
                          //             margin: EdgeInsets.only(
                          //                 right:
                          //                     getProportionateScreenWidth(8)),
                          //             child: Icon(
                          //               Icons.search_rounded,
                          //               color: Colors.black,
                          //             ),
                          //           ),
                          //           GestureDetector(
                          //             onTap: () {
                          //               Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         CartScreen()),
                          //               );
                          //             },
                          //             child: Container(
                          //               margin: EdgeInsets.only(
                          //                   right:
                          //                       getProportionateScreenWidth(
                          //                           8)),
                          //               child: Icon(
                          //                 Icons.shopping_cart_rounded,
                          //                 color: Colors.black,
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ProductImages(imageList: product.images),
                                  ProductActionsSection(product: product, setSelectedVariant: setSelectedVariant),
                                ],
                              ),
                            ),
                          ),
                          // Container(
                          //   child: SizedBox(height: getProportionateScreenHeight(80)),
                          //   color: Colors.grey,
                          // ),
                        ],
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

  Widget bottomProductBar() {
    UserPreferences prefs = new UserPreferences();
    bool hasDisPrice = product.discountPrice != null;
    // print("new color is set to $_selectedColor $_productDisPrice");

    return Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: product.variations != null && !_selected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Starting From",
                            style: cusBodyStyle(fontSize: getProportionateScreenHeight(14)),
                          ),
                          Text("${currency.format(product.priceRange != null ? product.priceRange : 0)}",
                              style: cusHeadingStyle(color: kPrimaryColor)),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: product.variations == null || _selected,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: hasDisPrice,
                            child: Text(
                              "Rs. ${hasDisPrice ? (numFormat.format(_productDisPrice ?? 0)) : null}  ",
                              style: cusPdctPageDisPriceStyle(getProportionateScreenHeight(20), Colors.black),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Rs. ${numFormat.format(_productOriPrice ?? 0)}",
                                style: hasDisPrice
                                    ? cusPdctOriPriceStyle(getProportionateScreenHeight(12))
                                    : cusPdctPageDisPriceStyle(getProportionateScreenHeight(24), kPrimaryColor),
                              ),
                              sizedBoxOfWidth(8),
                              Visibility(
                                visible: hasDisPrice,
                                child: Text(
                                  "${_productOriPrice == null ? product.calculatePercentageDiscount() : discountPercent}% OFF",
                                  // "20% OFF",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.red,
                                      fontSize: getProportionateScreenHeight(12),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: getProportionateScreenHeight(0.5),
                                    ),
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
            ),
            AddToCartFAB(
              product: product,
              fetchVariantId: () {
                // print("VAIATTION ${product.variations}");
                // print(_selectedColor);
                // print(_selectedSize);
                // return getSeletedVariantId();
                return getSeletedVariantId();
              },
            ),
            sizedBoxOfWidth(12),
            BuyNowFAB(
              productId: product.id,
              onTap: () {
                setState(() {
                  _variantId = getSeletedVariantId();
                });
                if (_variantId != null || product.variations == null)
                  AuthentificationService().currentUser != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              selectedCartItems: [
                                {CartItem.VARIATION_ID_KEY: _variantId, CartItem.PRODUCT_ID_KEY: product.id}
                              ],
                              onCheckoutPressed: selectedCheckoutButtonFromBuyNowCallback,
                              isBuyNow: true,
                            ),
                          ),
                        )
                      : Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationWrapper()));
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
      final formatedDateTime = DateTime.now();

      List orderedProducts = [];
      orderedProducts.add({
        OrderedProduct.PRODUCT_UID_KEY: selectedProductsUid.first[CartItem.PRODUCT_ID_KEY],
        if (selectedProductsUid.first[CartItem.VARIATION_ID_KEY] != null)
          OrderedProduct.VARIATION_UID_KEY: selectedProductsUid.first[CartItem.VARIATION_ID_KEY],
        OrderedProduct.ITEM_COUNT_KEY: 1,
      });
      OrderedProduct order =
          OrderedProduct(null, products: orderedProducts, orderDate: formatedDateTime, orderDetails: orderDetails);

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
