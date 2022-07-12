import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/size_config.dart';

// Cleaned
class AdsBanners extends StatelessWidget {
  final List imagesList;
  final List naviagationList;

  AdsBanners(this.imagesList, this.naviagationList, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: CarouselSlider.builder(
          itemCount: imagesList.length,
          options: CarouselOptions(
            viewportFraction: 1,
            // height: getProportionateScreenHeight(200),
            autoPlay: true,
            autoPlayInterval: Duration(milliseconds: 2500),
            autoPlayAnimationDuration: Duration(milliseconds: 500),
            reverse: false,
            aspectRatio: 2,
          ),
          itemBuilder: (context, i, id) {
            return GestureDetector(
              child: Container(
                // margin: EdgeInsets.all(getProportionateScreenWidth(8)),
                // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    imagesList[i],
                    width: getProportionateScreenWidth(500),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => naviagationList[i]),
                );
                // var url = imagesList[i];
                // print(url.toString());
              },
            );
          },
        ),
      ),
    );
  }
}
