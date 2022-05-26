import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

class Body extends StatelessWidget {
  const Body();

  @override
  Widget build(BuildContext context) {
    String imageURL = "https://cdn.shopify.com/s/files/1/1367/5201/products/Scv3TankTurboBlue-A2A3X-A2A3X-UBDR.A_ZH_ZH_800x.jpg?v=1647943311";
    String pdctName = "Vital T-shirt for Gym Buy today and ";
    String pdctBrand = "GymShark";
    num oriPrice = 23000;
    num disPrice = 20000;
    num discountPercentage = (oriPrice - disPrice) * 100 / oriPrice;

    return Column(
      children: [
        buildHeader(),
        Column(
          children: [
            buildPdctItem(imageURL, pdctName, pdctBrand, disPrice, oriPrice, discountPercentage),
            buildPdctItem(imageURL, pdctName, pdctBrand, disPrice, oriPrice, discountPercentage),
            buildPdctItem(imageURL, pdctName, pdctBrand, disPrice, oriPrice, discountPercentage),
          ],
        ),
      ],
    );
  }

  Container buildPdctItem(String imageURL, String pdctName, String pdctBrand, num disPrice, num oriPrice, num discountPercentage) {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenHeight(8)),
      child: Container(
        padding: EdgeInsets.only(bottom: getProportionateScreenHeight(4)),
        child: Row(
          children: [
            Container(
              width: getProportionateScreenHeight(90),
              height: getProportionateScreenHeight(90),
              margin: EdgeInsets.only(right: getProportionateScreenWidth(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(getProportionateScreenHeight(5)),
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pdctName, style: cusHeadingStyle(16, Colors.black.withOpacity(0.7))),
                  Text(pdctBrand, style: cusBodyStyle()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${currency.format(disPrice)}", style: cusHeadingStyle(16, Colors.black.withOpacity(0.7))),
                      sizedBoxOfWidth(4),
                      Text(
                        "${currency.format(oriPrice)}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: getProportionateScreenWidth(12),
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                            decoration: TextDecoration.lineThrough),
                      ),
                      sizedBoxOfWidth(4),
                      // Text(" -${discountPercentage.toStringAsFixed(0)}%", style: cusBodyStyle(null, null, Colors.red)),
                    ],
                  ),
                  sizedBoxOfHeight(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          // color: kPrimaryColor,
                          // padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: Row(
                            children: [
                              Container(
                                child: RatingBar(
                                  initialRating: 4.5,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 16,
                                  ratingWidget: RatingWidget(
                                    full: Icon(Icons.star_rounded, color: kPrimaryColor),
                                    half: Icon(Icons.star_half_rounded, color: kPrimaryColor),
                                    empty: Icon(Icons.star_outline_rounded, color: kPrimaryColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: kPrimaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_shopping_cart_rounded,
                                size: getProportionateScreenHeight(12),
                                color: Colors.white,
                              ),
                              sizedBoxOfWidth(2),
                              Text("ADD TO CART", style: TextStyle(color: Colors.white)),
                            ],
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
    );
  }

  Container buildHeader() {
    return Container(
      color: Colors.blue,
      child: AspectRatio(
        aspectRatio: 5 / 2,
        // child: Image.network(
        //   'https://firebasestorage.googleapis.com/v0/b/siteux-healthfix.appspot.com/o/offer_banners%2FHF-Banner-1.jpg?alt=media&token=2b8a7851-6276-4a7d-8468-1baf79e45882',
        //   fit: BoxFit.cover,
        // )
        child: Container(
          padding: EdgeInsets.all(getProportionateScreenHeight(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Featured Products", style: cusHeadingStyle(20, Colors.white, null, FontWeight.w400)),
              Text("Our Featured Products", style: cusHeadingStyle(16, Colors.white, null, FontWeight.w300)),
            ],
          ),
        ),
      ),
    );
  }
}
