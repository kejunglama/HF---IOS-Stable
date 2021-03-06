import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/product_details/provider_models/ColorVariations.dart';
import 'package:healthfix/screens/product_details/provider_models/VariantBuilder.dart';
import 'package:healthfix/size_config.dart';

import '../../../constants.dart';
import 'expandable_text.dart';

class ProductDescription extends StatelessWidget {
  final Product product;
  final sizes = new Set();
  final colors = new Set();
  final void Function(String size, Map color) setSelectedVariant;

  //
  // List jsonArray = [
  //   {"size": "S", "color": "FEAF3A", "price": 14000},
  //   {"size": "S", "color": "FE743A", "price": 15000},
  //   {"size": "M", "color": "FEAF3A", "price": 16000},
  //   {"size": "M", "color": "FEAA8A", "price": 16000},
  //   {"size": "M", "color": "FE113A", "price": 16000},
  //   {"size": "L", "color": "FE743A", "price": 20000},
  //   {"size": "L", "color": "3A81FE", "price": 22000},
  // ];

  ProductDescription({
    Key key,
    @required this.product,
    this.setSelectedVariant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List jsonArray;
    bool hasVariation = product.variations != null;
    if (hasVariation) {
      jsonArray = product.variations;
      jsonArray.forEach((variant) {
        sizes.add(variant["size"]);
        colors.add(variant["color"]);
      });
    }

    // print(product.variations);

    return Container(
      color: Color(0xFFF8F8F8),
      child: Container(
        // padding: EdgeInsets.only(top: getProportionateScreenHeight(24))
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenHeight(16), vertical: getProportionateScreenHeight(20)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${product.brand != null ? product.brand.toUpperCase() : ""}",
                    style: cusHeadingStyle(
                        fontSize: getProportionateScreenHeight(14),
                        color: kSecondaryColor,
                        fontWeight: FontWeight.w500)),
                sizedBoxOfHeight(8),
                Text(
                  product.title.capitalize(),
                  style: cusHeadingStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                  ),
                ),
                sizedBoxOfHeight(8),
                RatingBar(
                  initialRating: 4.5,
                  onRatingUpdate: (Rating) {},
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 16,
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star_rounded, color: Colors.orange),
                    half: Icon(Icons.star_half_rounded, color: Colors.orange),
                    empty: Icon(Icons.star_outline_rounded, color: Colors.orange),
                  ),
                ),
                sizedBoxOfHeight(12),

                ExpandableText(
                  content: product.description != null ? product.description.trim().replaceAll("\\n", "\n") : "",
                  maxLines: 2,
                ),

                // Product Title

                // const SizedBox(height: 16),
                // Text(product.highlights),
                // const SizedBox(height: 16),

                // Product Variation with Price
                ProductVariationDescription(
                  product: product,
                  sizes: sizes,
                  jsonArray: jsonArray,
                  colors: colors,
                  setSelectedVariant: setSelectedVariant,
                ),

                const SizedBox(height: 12),
                // Text(
                // product.description != null ? product.description.trim().replaceAll("\\n", "\n") : "",
                //   style: cusBodyStyle(),
                // ),

                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    text: "From ",
                    style: cusHeadingStyle(
                        fontSize: 14, color: kSecondaryColor, fontWeight: FontWeight.w400, letterSpacing: 0.25),
                    children: [
                      TextSpan(
                        text: "${product.seller}",
                        style: TextStyle(
                            // decoration: TextDecoration.underline,
                            ),
                      ),
                    ],
                  ),
                ),
                sizedBoxOfHeight(80),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductVariationDescription extends StatefulWidget {
  final void Function(String size, Map color) setSelectedVariant;

  ProductVariationDescription({
    Key key,
    @required this.product,
    @required this.sizes,
    @required this.jsonArray,
    @required this.colors,
    this.setSelectedVariant,
  }) : super(key: key);

  final Product product;
  final Set sizes;
  final List jsonArray;
  final Set colors;

  @override
  State<ProductVariationDescription> createState() => _ProductVariationDescriptionState();
}

class _ProductVariationDescriptionState extends State<ProductVariationDescription> {
  List _colors = [];
  String _selectedSize;
  Map _selectedColor;
  num _selectedColorIndex;

  setSizeAndFetchColors(String size, List colors) {
    setState(() {
      _selectedColorIndex = 0;
      _selectedSize = size;
      _colors = colors;
      setColor(_colors[0]);
      // print(_selectedColorIndex);
    });
  }

  setColor(Map color) {
    setState(() {
      // print("color is set to $_selectedColor");
      _selectedColor = color;
      widget.setSelectedVariant(_selectedSize, _selectedColor);
    });
  }

  setSelectedColorIndex(num i) {
    setState(() {
      _selectedColorIndex = i;
    });
  }

  bool hasColorVariation() {
    return widget.colors.isNotEmpty ? widget.colors.first != null : false;
  }

  bool hasSizeVariation() {
    return widget.sizes.isNotEmpty ? widget.sizes.first != null : false;
  }

  @override
  Widget build(BuildContext context) {
    bool hasVariations = widget.jsonArray != null;
    // print("${widget.colors.isNotEmpty ? widget.colors.first != null : false}");
    // print("size: ${hasSizeVariation()} color:${hasColorVariation()}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasVariations)
          Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(12)),
              Visibility(
                visible: hasSizeVariation(),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(right: getProportionateScreenWidth(12)),
                      child: Text(
                        "Select Size :",
                        style: cusHeadingStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(12)),
                    variantsBuilder(
                      variants: widget.sizes.toList(),
                      json: widget.jsonArray,
                      setSize: setSizeAndFetchColors,
                      setSelectedColorIndex: setSelectedColorIndex,
                    ),
                    SizedBox(height: getProportionateScreenHeight(12)),
                  ],
                ),
              ),
              // SizedBox(height: getProportionateScreenHeight(20)),
              sizedBoxOfHeight(12),
              Visibility(
                visible: hasColorVariation(),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(right: getProportionateScreenWidth(12)),
                      child: Text(
                        "Color :",
                        style: cusHeadingStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(12)),
                    Visibility(
                      visible: hasColorVariation(),
                      child: ColorvariantsBuilder(
                        selectedIndex: _selectedColorIndex ?? null,
                        colors: _colors.isNotEmpty ? _colors : widget.colors.toList(),
                        selectable: _colors.isNotEmpty || hasColorVariation(),
                        setColor: setColor,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(12)),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

// class variantRadioBt1n extends StatelessWidget {
//
//
//   const variantRadioBtn(this.selected,
//       this.id, {
//         Key key,
//       }) : super(key: key);
//
//   final int id;
//   final int selected;
//
//   @override
//   State<variantRadioBtn> createState() => _variantRadioBtnState();
// }
//
// class _variantRad23ioBtnState extends State<variantRadioBtn> {
//   @override
//   Widget build(BuildContext context) {
//     // int Selected = widget.selectIndex ?? 0;
//
//     var _selected = selected;
//     return Container(
//       width: 30,
//       height: 30,
//       decoration: BoxDecoration(
//         border: Border.all(
//           width: 1,
//           color: _selected == id ? kPrimaryColor : Colors.grey,
//         ),
//       ),
//       child: Center(
//           child: Text(
//             "S",
//             style: TextStyle(
//               color: _isSelected ? kPrimaryColor : Colors.grey,
//             ),
//           )),
//     );
//   }
// }
