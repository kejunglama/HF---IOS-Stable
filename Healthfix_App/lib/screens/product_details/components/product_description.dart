import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void Function(String size, Map color) setSelectedVariant;

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
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenHeight(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${product.variant.toUpperCase()}", style: cusHeadingStyle(getProportionateScreenHeight(14), Colors.black87, null, FontWeight.w500)),
              sizedBoxOfHeight(8),
              Text(product.title.capitalize(), style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 24,
                  color: kSecondaryColor,
                )
              )),

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
              Text(product.description.trim().replaceAll("\\n", "\n"), style: cusBodyStyle(),),
              // ExpandableText(
              //   title: "",
              //   content: product.description,
              // ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  text: "By ",
                  style: cusHeadingStyle(getProportionateScreenHeight(14), kSecondaryColor),
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
            ],
          ),
        ],
      ),
    );
  }
}

class ProductVariationDescription extends StatefulWidget {
  void Function(String size, Map color) setSelectedVariant;

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
      _selectedSize = size;
      _selectedColorIndex = 0;
      _colors = colors;
      setColor(_colors[0]);
    });
  }

  setColor(Map color) {
    setState(() {
      _selectedColor = color;
      if (_selectedColor != null && _selectedSize != null) widget.setSelectedVariant(_selectedSize, _selectedColor);
      // print(_selectedColor + " " + _selectedSize);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasVariations = widget.jsonArray != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasVariations)
          Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(12)),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: getProportionateScreenWidth(12)),
                    child: Text(
                      "Size: ",
                      style: cusHeadingStyle(getProportionateScreenWidth(12), Colors.grey),
                    ),
                  ),
                  // SizedBox(height: getProportionateScreenHeight(12)),
                  variantsBuilder(variants: widget.sizes.toList(), json: widget.jsonArray, setSize: setSizeAndFetchColors),
                ],
              ),
              // SizedBox(height: getProportionateScreenHeight(20)),
              sizedBoxOfHeight(12),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(right: getProportionateScreenWidth(12)),
                    child: Text(
                      "Available Colors: ",
                      style: cusHeadingStyle(getProportionateScreenWidth(12), Colors.grey),
                    ),
                  ),
                  // SizedBox(height: getProportionateScreenHeight(12)),
                  ColorvariantsBuilder(
                    selectedIndex: _selectedColorIndex ?? 0,
                    colors: _colors.isNotEmpty ? _colors : widget.colors.toList(),
                    selectable: _colors.isNotEmpty,
                    setColor: setColor,
                  ),
                ],
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
