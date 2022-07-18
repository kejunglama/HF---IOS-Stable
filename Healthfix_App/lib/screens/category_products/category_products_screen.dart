import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Product.dart';

import 'components/body.dart';

class CategoryProductsScreen extends StatelessWidget {
  final ProductType productType;
  final String subProductType;
  final String searchString;
  final List<Map> productTypes;

  const CategoryProductsScreen({
    Key key,
    this.productType,
    this.productTypes,
    this.searchString,
    this.subProductType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: kPrimaryColor,
        ),
        body: Body(
          productType: productType,
          productTypes: productTypes,
          subProductType: subProductType,
          searchString: searchString ?? null,
        ),
      ),
    );
  }
}
