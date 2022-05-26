import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/size_config.dart';

// Cleaned
class AdsBanners extends StatelessWidget {
  List imagesList;

  AdsBanners(this.imagesList, {key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: CarouselSlider.builder(
          itemCount: imagesList.length,
          options: CarouselOptions(
            viewportFraction: 0.9,
            height: getProportionateScreenHeight(172),
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            reverse: false,
            aspectRatio: 5.0,
          ),
          itemBuilder: (context, i, id) {
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.all(getProportionateScreenWidth(8)),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    imagesList[i],
                    width: getProportionateScreenWidth(500),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                var url = imagesList[i];
                print(url.toString());
              },
            );
          },
        ),
      ),
    );
  }
}
