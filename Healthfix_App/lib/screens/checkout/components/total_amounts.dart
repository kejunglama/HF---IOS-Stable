import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class TotalAmounts extends StatelessWidget {
  final num deliveryCharge;
  final int cartTotal;
  TotalAmounts(
    this.cartTotal,
    this.deliveryCharge, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var numFormat = NumberFormat('#,##,000');

    return Column(
      children: [
        buildPriceRow("Sub-Total", numFormat.format(cartTotal) ?? "NA"),
        buildPriceRow("Delivery Charge", numFormat.format(deliveryCharge)),
        buildPriceRow("Total",
            numFormat.format(cartTotal + deliveryCharge).toString(), true),
      ],
    );
  }

  Container buildPriceRow(String text, String price, [bool isMain]) {
    bool _isMain = isMain ?? false;
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(6),
          horizontal: getProportionateScreenHeight(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: cusPdctNameStyle),
          Text("Rs. " + price,
              style: _isMain
                  ? cusPdctDisPriceStyle()
                  : cusPdctDisPriceStyle(null, Colors.black)),
        ],
      ),
    );
  }
}
