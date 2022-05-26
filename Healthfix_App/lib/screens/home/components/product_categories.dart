import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/category_products/category_products_screen.dart';
import 'package:healthfix/size_config.dart';

import 'product_type_box.dart';

// Cleaned
class ProductCategories extends StatelessWidget {
  void Function() goToCategory;

  ProductCategories(
    this.goToCategory, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map> _pdctCategories = new List.from(pdctCategories);
    if(_pdctCategories[0]["product_type"] == ProductType.All) _pdctCategories.removeAt(0);
    // print(_pdctCategories);
    // print(pdctCategories);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(10)),
          child: Padding(
            padding: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category", style: cusHeadingStyle()),
                GestureDetector(onTap: goToCategory, child: Text("See More >", style: cusHeadingLinkStyle)),
              ],
            ),
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(110),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: [
              ...List.generate(
                _pdctCategories.length,
                (index) {
                  return ProductTypeBox(
                    imageLocation: _pdctCategories[index][IMAGE_LOCATION_KEY],
                    title: _pdctCategories[index][TITLE_KEY],
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryProductsScreen(
                            productType: _pdctCategories[index][PRODUCT_TYPE_KEY],
                            productTypes: _pdctCategories,
                            subProductType: "",
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
