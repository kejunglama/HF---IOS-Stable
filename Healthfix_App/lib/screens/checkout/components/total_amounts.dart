import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class TotalAmounts extends StatelessWidget {
  num deliveryCharge;
  double cartTotal;
  TotalAmounts(this.cartTotal, this.deliveryCharge, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildPriceRow("Sub-Total", cartTotal.toString() ?? "10,000"),
        buildPriceRow("Delivery Charge", deliveryCharge.toString()),
        buildPriceRow("Total", (cartTotal + deliveryCharge).toString() , true),
      ],
    );
  }

  Container buildPriceRow(String text, String price, [bool isMain]) {
    bool _isMain = isMain ?? false;
    return Container(
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(6), horizontal: getProportionateScreenHeight(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: cusPdctNameStyle),
          Text("Rs. " + price, style: _isMain ? cusPdctDisPriceStyle() : cusPdctDisPriceStyle(null, Colors.black)),
        ],
      ),
    );
  }
}