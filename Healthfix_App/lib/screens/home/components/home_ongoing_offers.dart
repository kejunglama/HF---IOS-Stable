import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

// Cleaned
class OngoingOffers extends StatelessWidget {
  final List<String> offerImagesList;

  OngoingOffers(this.offerImagesList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Ongoing Offers | ", style: cusCenterHeadingStyle()),
              Text("November Deals", style: cusCenterHeadingAccentStyle),
            ],
          ),

          sizedBoxOfHeight(8),

          Container(
            child: Container(
              margin: EdgeInsets.all(getProportionateScreenHeight(8)),
              child: CarouselSlider.builder(
                itemCount: offerImagesList.length,
                options: CarouselOptions(
                  viewportFraction: 0.65,
                  height: getProportionateScreenHeight(200),
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  reverse: false,
                  // aspectRatio: 1,
                ),
                itemBuilder: (context, i, id) {
                  return GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        offerImagesList[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      var url = offerImagesList[i];
                      print(url.toString());
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
