import 'package:flutter/material.dart';
import 'package:healthfix/components/default_button.dart';

import '../../constants.dart';
import '../../data.dart';
import '../../size_config.dart';

class PaymentOptionsScreen extends StatefulWidget {
  Map orderDetails;
  List selectedCartItems;
  Future<void> Function(Map orderDetails, List selectedProductsUid) onCheckout;

  PaymentOptionsScreen({this.orderDetails, this.onCheckout, this.selectedCartItems});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Payment Options",
            style: cusHeadingStyle(),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  for (var i = 0; i < payMethods.length; i++)
                    buildPayMethodCard(payMethods[i]["id"], payMethods[i]["heading"], payMethods[i]["sub"], payMethods[i]["url"]),
                ],
              ),
              DefaultButton(
                text: "Proceed to Payment",
                press: () {
                  // if (address.phone != phoneFieldController.text) address.phone = phoneFieldController.text;
                  //
                  // final Map _address = address.toMap();
                  // _address["email"] = emailFieldController.text;
                  // final Map totals = {"cartTotal": cartTotal, "deliveryCharge": deliveryCharge, "netTotal": cartTotal + deliveryCharge};
                  //
                  // print(_address);
                  // print("");
                  // print(totals);
                  // final Map orderDetails = {
                  //   "address" : _address,
                  //   "totals": totals,
                  //   "pay_method": "",
                  // };

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PaymentOptionsScreen(onCheckout: widget.onCheckout, orderDetails:widget.orderDetails),
                  //   ),
                  // );

                  // print(widget.selectedCartItems);
                  if (selected == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please Select a Payment Method")),
                    );
                  } else {
                    widget.orderDetails["pay_method"] = selected;
                    print(widget.orderDetails);
                    widget.onCheckout(widget.orderDetails, widget.selectedCartItems);
                  }

                  // (orderDetails);
                },
              ),
            ],
          ),
        ));
  }

  Widget buildPayMethodCard(String id, String heading, String sub, String url) {
    bool isSelected = selected == id;
    print(id);
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = id;
          print(selected);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
          vertical: getProportionateScreenWidth(5),
        ),
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          // color: !isSelected ? kPrimaryColor.withOpacity(0.1) : null,
          boxShadow: !isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]
              : null,
          border: isSelected
              ? Border.fromBorderSide(
                  BorderSide(width: 1, color: Colors.green),
                )
              : Border.fromBorderSide(
                  BorderSide(width: 1, color: Colors.white),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(50),
              height: getProportionateScreenWidth(50),
              child: Image.network(url),
            ),
            sizedBoxOfWidth(15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading, style: cusHeadingStyle()),
                  Text(sub, style: cusBodyStyle()),
                ],
              ),
            ),
            Visibility(
              visible: isSelected,
              child: Icon(Icons.check_circle_outline_rounded, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
