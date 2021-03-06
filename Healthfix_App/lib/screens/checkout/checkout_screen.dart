// ignore_for_file: must_be_immutable

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/models/Address.dart';
import 'package:healthfix/models/CartItem.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/checkout/payment_options_screen.dart';
import 'package:healthfix/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:healthfix/services/data_streams/addresses_stream.dart';
import 'package:healthfix/services/database/meals_database_helper.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import '../../constants.dart';
import 'components/order_items.dart';
import 'components/total_amounts.dart';

class CheckoutScreen extends StatefulWidget {
  final Future<void> Function(Map orderDetails, List selectedCartItems) onCheckoutPressed;
  final Future<void> Function(Map orderDetails, List selectedCartItems) onCheckoutPressedForMeals;
  final List selectedCartItems;
  bool isBuyNow;
  final bool isMeal;

  CheckoutScreen({
    Key key,
    this.onCheckoutPressed,
    this.selectedCartItems,
    this.isBuyNow,
    this.isMeal,
    this.onCheckoutPressedForMeals,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  num cartTotal;
  num deliveryCharge;
  List<Map> arr;

  final AddressesStream addressesStream = AddressesStream();
  final TextEditingController phoneFieldController = TextEditingController();
  final TextEditingController emailFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressesStream.init();
    widget.isBuyNow = widget.isBuyNow ?? false;
  }

  @override
  void dispose() {
    super.dispose();
    phoneFieldController.dispose();
    emailFieldController.dispose();
    addressesStream.dispose();
  }

  fetchAddress(String addressID) async {
    var _ad = await UserDatabaseHelper().getAddressFromId(addressID);
    address = _ad;
    phoneFieldController.text = address.phone;
    emailFieldController.text = "kejunglama@gmail.com";
  }

  Address address;

  @override
  Widget build(BuildContext context) {
    arr = [];

    print("onCheckoutPressedForMeals");
    print(widget.onCheckoutPressedForMeals);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: cusHeadingStyle(),
        ),
      ),
      body: StreamBuilder<Object>(
          stream: addressesStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List addresses = snapshot.data;
              // fetchAddress(addresses[0]);

              return FutureBuilder(
                  future: (address == null) ? fetchAddress(addresses[0]) : null,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              buildAddressSection(context),
                              sizedBoxOfHeight(12),
                              buildIconWithTextField(Icons.smartphone_rounded, "Your Number", phoneFieldController),
                              sizedBoxOfHeight(12),
                              buildIconWithTextField(Icons.mail_outline_rounded, "Your Email", emailFieldController),
                              sizedBoxOfHeight(12),
                              Divider(thickness: 0.1, color: Colors.cyan),
                              sizedBoxOfHeight(12),
                              // Order Items
                              // OrderItems(getCartPdct: getCartPdct),
                              OrderItems(
                                selectedCartItems: widget.selectedCartItems,
                                isBuyNow: widget.isBuyNow,
                                isMeal: widget.isMeal,
                              ),

                              sizedBoxOfHeight(12),
                              Divider(thickness: 0.1, color: Colors.cyan),
                              sizedBoxOfHeight(12),
                              widget.isBuyNow ?? false
                                  ? widget.isMeal ?? false
                                      // For Meal
                                      ? FutureBuilder(
                                          future: MealsDatabaseHelper().getMealsWithID(widget.selectedCartItems.first),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              Meal meal = snapshot.data;
                                              int price = meal.discountPrice ?? meal.originalPrice;
                                              cartTotal = price.toInt();
                                              deliveryCharge = 100;
                                              // print(cartTotal.runtimeType);
                                              return TotalAmounts(price, deliveryCharge);
                                            }
                                            return CircularProgressIndicator();
                                          })
                                      // From Buy Now
                                      : FutureBuilder(
                                          future: ProductDatabaseHelper()
                                              .getProductWithID(widget.selectedCartItems[0][CartItem.PRODUCT_ID_KEY]),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              print("product");
                                              print(widget.selectedCartItems[0]);
                                              Product pdct = snapshot.data;
                                              print(pdct.variations);
                                              int price;
                                              if (pdct.variations == null)
                                                price = pdct.discountPrice.toInt();
                                              else
                                                price = pdct.variations
                                                    .where((p) =>
                                                        p[CartItem.VARIATION_ID_KEY] ==
                                                        widget.selectedCartItems[0][CartItem.VARIATION_ID_KEY])
                                                    .first["price"];
                                              cartTotal = price;
                                              deliveryCharge = 100;
                                              // print(cartTotal.runtimeType);
                                              return TotalAmounts(price, deliveryCharge);
                                            }
                                            return CircularProgressIndicator();
                                          })
                                  // From Cart
                                  : FutureBuilder(
                                      future: UserDatabaseHelper().selectedCartTotal(widget.selectedCartItems),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          cartTotal = snapshot.data;
                                          deliveryCharge = 100;
                                          print(cartTotal.runtimeType);
                                          return TotalAmounts(cartTotal, deliveryCharge);
                                        }
                                        return CircularProgressIndicator();
                                      }),
                            ],
                          ),
                          DefaultButton(
                            text: "Proceed to Payment",
                            // press: () {
                            //   if (widget.isMeal) _selectDateTime(context);
                            // },
                            press: () {
                              if (address.phone != phoneFieldController.text) address.phone = phoneFieldController.text;

                              final Map _address = address.toMap();
                              _address["email"] = emailFieldController.text;
                              final Map totals = {
                                "cartTotal": cartTotal,
                                "deliveryCharge": deliveryCharge,
                                "netTotal": cartTotal + deliveryCharge
                              };
                              final Map orderDetails = {
                                "address": _address,
                                "totals": totals,
                                "pay_method": "",
                              };

                              if (widget.isMeal ?? false)
                                _selectDateTime(context).then((DateTime deliveryDateTime) {
                                  if (deliveryDateTime != null) {
                                    orderDetails["deliveryDateTime"] = deliveryDateTime;
                                    print(deliveryDateTime);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentOptionsScreen(
                                          onCheckout: widget.onCheckoutPressedForMeals,
                                          orderDetails: orderDetails,
                                          selectedCartItems: widget.selectedCartItems,
                                        ),
                                      ),
                                    );
                                  }
                                });
                              else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentOptionsScreen(
                                      onCheckout: widget.isMeal ?? false
                                          ? widget.onCheckoutPressedForMeals
                                          : widget.onCheckoutPressed,
                                      orderDetails: orderDetails,
                                      selectedCartItems: widget.selectedCartItems,
                                    ),
                                  ),
                                );
                              }

                              // (orderDetails);
                            },
                          ),
                          // buildHintText("District"),
                          // buildTextFormField("1234 Forest Road"),
                        ],
                      ),
                    );
                  });
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
          }),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime _selectedDate = await showDatePicker(
      context: context,
      initialDate: now.hour < 12 ? now : DateTime(now.year, now.month, now.day + 1),
      firstDate: now.hour < 12 ? now : DateTime(now.year, now.month, now.day + 1),
      lastDate: DateTime(now.year, now.month, now.day + 7),
      helpText: "Choose Your Delivery Date".toUpperCase(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light()
              .copyWith(primaryColor: kPrimaryColor, colorScheme: ColorScheme.light(primary: kPrimaryColor)),
          child: child,
        );
      },
    );
    return _selectedDate;
  }

  // Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    DateTime _now = DateTime.now();
    final _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _now.hour, minute: _now.minute),
      helpText: "Choose Your Delivery Time".toUpperCase(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kPrimaryColor,
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
              onSurface: Colors.black38,
              onBackground: kPrimaryColor,
            ),
          ),
          child: child,
        );
      },
    );
    return _selectedTime;
  }

  Future<DateTime> _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    if (date == null) return null;
    final time = await _selectTime(context);
    if (time == null) return null;

    DateTime deliveryDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    return deliveryDateTime;
  }

  Row buildIconWithTextField(IconData iconData, String hintText, TextEditingController textController) {
    return Row(
      children: [
        Icon(
          iconData,
          color: kSecondaryColor.withOpacity(0.8),
          size: getProportionateScreenHeight(20),
        ),
        sizedBoxOfWidth(12),
        Expanded(
          child: Container(
            height: getProportionateScreenHeight(34),
            child: buildTextFormField(
              textController,
              hintText,
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddressSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.my_location_rounded,
              color: kSecondaryColor.withOpacity(0.8),
              size: getProportionateScreenHeight(20),
            ),
            sizedBoxOfWidth(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address != null ? address.receiver : "Receiver's Name", style: cusBodyStyle()),
                Row(
                  children: [
                    Text((address != null ? address.address : "Address") + ", ", style: cusBodyStyle()),
                    Text(address != null ? address.city : "City", style: cusBodyStyle()),
                  ],
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            Address _address = await Navigator.push(
                context, MaterialPageRoute(builder: (context) => ManageAddressesScreen(isSelectAddressScreen: true)));
            setState(() {
              address = _address;
              phoneFieldController.text = address.phone;
            });
            // print(address.receiver);
          },
          child: Text("EDIT",
              style: cusBodyStyle(
                  fontSize: getProportionateScreenHeight(16),
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor.withOpacity(0.8))),
        ),
      ],
    );
  }

  TextFormField buildTextFormField(TextEditingController textController, String hint) {
    return TextFormField(
      // keyboardType: TextInputType.emailAddress,
      style: TextStyle(fontSize: getProportionateScreenHeight(14)),
      controller: textController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: EdgeInsets.all(getProportionateScreenHeight(10)),
        hintText: hint,
        hintStyle: cusHeadingStyle(
            fontSize: getProportionateScreenHeight(14), color: Colors.grey, fontWeight: FontWeight.w400),

        // labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

// getCartPdct(Map val) {
//   // print(val);
//   arr.add(val);
//   // String key = val.keys.toString();
//   // List _arr = [];
//   // for (int i = 0; i < arr.length; i++) {
//   //   if (arr[i].keys.toString() != key) {
//   //     // print("arr.add(val)");
//   //     continue;
//   //   }
//   //   // arr.add(val);
//   //   // print(val);
//   //
//   // }
//   // print(arr);
//   var _arr = arr.toSet().toList();
//   print(arr);
//   // var seen = Set<Map>();
//   // List<Map> uniqueList = arr.where((country) => seen.add(country)).toList();
//   // print(uniqueList);
//
//   // arr.forEach((e) {
//   //   String key = val.keys.toString();
//   //   if (e.keys.toString() != key) {
//   //     print("arr.add(val)");
//   //     continue;
//   //   }
//   //   _arr.add(val);
//   // });
//   // print(arr);
// }
}
