import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/product_details/provider_models/ProductImageSwiper.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ProductImages extends StatefulWidget {
  final BoxFit imageFit;

  const ProductImages({
    Key key,
    @required this.imageList,
    this.imageFit,
  }) : super(key: key);

  final List imageList;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductImageSwiper(),
      child: Consumer<ProductImageSwiper>(
        builder: (context, productImagesSwiper, child) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // GestureDetector(
              //   onHorizontalDragUpdate: (details) {
              //     int sensitivity = 10;
              //     // Swiping in right direction.
              //     if (details.delta.dx > sensitivity) {
              //       productImagesSwiper.currentImageIndex--;
              //       productImagesSwiper.currentImageIndex +=
              //           product.images.length;
              //       productImagesSwiper.currentImageIndex %=
              //           product.images.length;
              //     }
              //
              //     // Swiping in left direction.
              //     else if (details.delta.dx < -sensitivity) {
              //       productImagesSwiper.currentImageIndex++;
              //       productImagesSwiper.currentImageIndex %=
              //           product.images.length;
              //     }
              //   },
              //   // onSwipeLeft: () {
              //   //   productImagesSwiper.currentImageIndex++;
              //   //   productImagesSwiper.currentImageIndex %=
              //   //       product.images.length;
              //   // },
              //   // onSwipeRight: () {
              //   //   productImagesSwiper.currentImageIndex--;
              //   //   productImagesSwiper.currentImageIndex +=
              //   //       product.images.length;
              //   //   productImagesSwiper.currentImageIndex %=
              //   //       product.images.length;
              //   // },
              //   child: Container(
              //     padding: const EdgeInsets.all(16),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       // borderRadius: BorderRadius.all(
              //       //   Radius.circular(30),
              //       // ),
              //     ),
              //     child: SizedBox(
              //       height: SizeConfig.screenHeight * 0.35,
              //       width: SizeConfig.screenWidth * 1,
              //       child: Image.network(
              //         product.images[productImagesSwiper.currentImageIndex],
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //   ),
              // ),
              // Product Image Slider
              Container(
                height: getProportionateScreenHeight(360),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: getProportionateScreenHeight(360),
                    // aspectRatio: SizeConfig.screenWidth /getProportionateScreenHeight(360),
                    autoPlay: true,
                    enableInfiniteScroll: false,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayInterval: Duration(seconds: 10),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        productImagesSwiper.currentImageIndex = index;
                      });
                    },
                  ),
                  items: widget.imageList
                      .map(
                        (item) => Container(
                          // height: SizeConfig.screenWidth,
                          // width: SizeConfig.screenWidth,
                          child: Image.network(item,
                              fit: widget.imageFit ?? BoxFit.cover),
                        ),
                      )
                      .toList(),
                ),
              ),
              // SizedBox(height: 10),
              // Slider Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imageList.map((urlOfItem) {
                  int index = widget.imageList.indexOf(urlOfItem);
                  return Container(
                    width: getProportionateScreenHeight(8),
                    height: getProportionateScreenHeight(8),
                    margin: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(10),
                        horizontal: getProportionateScreenHeight(2)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: productImagesSwiper.currentImageIndex == index
                          ? kSecondaryColor
                          : kSecondaryColor.withOpacity(0.2),
                    ),
                  );
                }).toList(),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ...List.generate(
              //       product.images.length,
              //       (index) =>
              //           buildSmallPreview(productImagesSwiper, index: index),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 30,
              //   child: SliderIndicator(
              //     length: product.images.length,
              //     activeIndex: productImagesSwiper.currentImageIndex,
              //     activeIndicator: const Icon(Icons.circle),
              //     indicator: Sz(
              //       // margin: EdgeInsets.all(100.0),
              //       decoration: BoxDecoration(
              //           color: Colors.orange,
              //           shape: BoxShape.circle
              //       ),
              //     )
              //     // activeIndicator: const Icon(Icons.access_alarms),
              //   ),
              // )
            ],
          );
        },
      ),
    );
  }

  Widget buildSmallPreview(ProductImageSwiper productImagesSwiper,
      {@required int index}) {
    return GestureDetector(
      onTap: () {
        productImagesSwiper.currentImageIndex = index;
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
        padding: EdgeInsets.all(getProportionateScreenHeight(8)),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: productImagesSwiper.currentImageIndex == index
                  ? kPrimaryColor
                  : Colors.transparent),
        ),
        child: Image.network(widget.imageList[index]),
      ),
    );
  }
}
