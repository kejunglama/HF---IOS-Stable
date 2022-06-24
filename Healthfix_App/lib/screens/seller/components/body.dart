import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/size_config.dart';

class Body extends StatelessWidget {
  const Body({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map sellerData = {
      "name": "Fitcal ",
      "imageUrl": "https://fitcal.com.np/wp-content/uploads/2022/03/cropped-Fitcal-1.png",
      "productType": ProductType.Food,
    };
    return Container(
      padding: EdgeInsets.all(getProportionateScreenHeight(12)),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: getProportionateScreenWidth(100),
              width: getProportionateScreenWidth(100),
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(-3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Image.network(
                sellerData["imageUrl"],
              ),
            ),
            sizedBoxOfWidth(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sellerData["name"], style: cusHeadingStyle()),
                Text("Main Category: ", style: cusBodyStyle()),
                Text("${sellerData["productType"].toString()}", style: cusBodyStyle(fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
