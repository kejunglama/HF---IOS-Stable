import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/screens/category_products/category_products_screen.dart';
import 'package:healthfix/size_config.dart';

class Body extends StatelessWidget {
  Body();

  final catKey_all = GlobalKey();
  final catKey_nutri = GlobalKey();
  final catKey_suppl = GlobalKey();
  final catKey_foods = GlobalKey();
  final catKey_cloth = GlobalKey();
  final catKey_explr = GlobalKey();

  Future scrollToCat([GlobalKey key]) async {
    final context = key.currentContext;
    await Scrollable.ensureVisible(context, duration: Duration(milliseconds: 500), alignment: 1);
  }

  @override
  Widget build(BuildContext context) {
    List keyList = [
      catKey_all,
      catKey_nutri,
      catKey_suppl,
      catKey_foods,
      catKey_cloth,
      catKey_explr,
    ];

    return SafeArea(
      child: Row(
        children: [
          CategoryList(pdctCategories, scrollToCat, keyList),
          CategoryHierarchyList(PdctSubCategories, keyList),
        ],
      ),
    );
  }
}

class CategoryHierarchyList extends StatelessWidget {
  List keyList;
  Map categoryHierarchy;

  CategoryHierarchyList(this.categoryHierarchy, this.keyList);

  @override
  Widget build(BuildContext context) {
    Map _ch = new Map.from(categoryHierarchy);
    _ch.remove("All Products");
    print(_ch);
    var i = 1;

    return Expanded(
      flex: 4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var entry in _ch.entries)
              Column(
                key: keyList[i++],
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(40, 20, 20, 10),
                    child: GestureDetector(
                        onTap: () {
                          // print(j++);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  productType: pdctCategories.where((ele) => ele[TITLE_KEY] == entry.key).first[PRODUCT_TYPE_KEY],
                                  productTypes: pdctCategories,
                                ),
                              ));
                        },
                        child: Text(entry.key, style: cusHeadingStyle(18, kPrimaryColor))),
                  ),
                  for (var arrValue in entry.value)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryProductsScreen(
                                  productType: pdctCategories.where((ele) => ele[TITLE_KEY] == entry.key).first[PRODUCT_TYPE_KEY],
                                  productTypes: pdctCategories,
                                  subProductType: arrValue,
                                ),
                              ));
                        },
                        child: Text(
                          arrValue,
                          style: cusBodyStyle(16),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  List categories;
  List keyList;
  Future Function([GlobalKey key]) scrollToCat;

  String ICON_KEY = "icon";
  String IMAGE_LOCATION_KEY = "image_location";
  String TITLE_KEY = "title";

  CategoryList(this.categories, this.scrollToCat, this.keyList);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.grey.shade100),
        ),
        color: Colors.white,
      ),
      child: Container(
        width: SizeConfig.screenWidth * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i < categories.length; i++)
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    scrollToCat(keyList[i]);
                  },
                  child: Center(
                    child: Container(
                      height: getProportionateScreenHeight(120),
                      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(20)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: getProportionateScreenHeight(430),
                            height: getProportionateScreenHeight(50),
                            margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
                            child: Image.asset(categories[i][IMAGE_LOCATION_KEY]),
                          ),
                          Text(
                            categories[i][TITLE_KEY],
                            style: cusHeadingStyle(getProportionateScreenHeight(14), kPrimaryColor, null, FontWeight.w300),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
