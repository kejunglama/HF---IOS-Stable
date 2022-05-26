import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_card.dart';
import 'package:healthfix/components/rounded_icon_button.dart';
import 'package:healthfix/components/search_field.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/services/data_streams/category_products_stream.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

class Body extends StatefulWidget {
  ProductType productType;
  final String subProductType;
  String searchString;
  final List<Map> productTypes;

  Body({
    this.productType,
    this.searchString,
    this.productTypes,
    this.subProductType,
  });

  @override
  _BodyState createState() => _BodyState(categoryProductsStream: CategoryProductsStream(productType));
}

class _BodyState extends State<Body> {
  CategoryProductsStream categoryProductsStream;

  Map category;
  String _categoryName;
  String _selectedSubCat;
  List<dynamic> _categoryList = [];
  List<String> _subCatList = [];

  _BodyState({@required this.categoryProductsStream});

  @override
  void initState() {
    super.initState();
    categoryProductsStream.init();
    // print(widget.productTypes);

    // Fetch Category
    category = widget.productTypes.where((type) => type["product_type"] == widget.productType).first;
    _categoryName = category["title"];

    // Fetch All Product Types
    widget.productTypes.forEach((pt) {
      _categoryList.add([EnumToString.convertToString(pt['product_type']), pt["title"]]);
    });

    // Fetch Sub Categories
    fetchSubCategories(_categoryName);
    _selectedSubCat = (widget.subProductType != null) ? widget.subProductType : "";
    // if (category["product_type"] == ProductType.All) {}
  }

  @override
  void dispose() {
    super.dispose();
    categoryProductsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  sizedBoxOfHeight(20),
                  buildHeadBar(),
                  sizedBoxOfHeight(20),
                  subCategory(),
                  sizedBoxOfHeight(10),
                  searchBar(),
                  buildProductCatalog(),
                  sizedBoxOfHeight(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container searchBar() {
    return Container(
      child: SearchField(
        onSubmit: (value) {
          setState(() {
            widget.searchString = value;
          });
          reInitProductStream("", widget.searchString);
        },
      ),
    );
  }

  Container subCategory() {
    return Container(
      height: getProportionateScreenHeight(20),
      child: ListView(
        children: [
          for (String _subCat in _subCatList)
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSubCat = _subCat;
                  if (_categoryName == "All Products") {
                    fetchCategoryWithTypeName(fetchTypeNameWithName(_subCat));
                    reInitProductStream();
                    _categoryName = category["title"];
                    fetchSubCategories(_categoryName);
                  } else
                    reInitProductStream(_selectedSubCat);
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Text(
                  _subCat,
                  style: _selectedSubCat == _subCat ? cusBodyStyle(14, FontWeight.w500, kPrimaryColor, 0.5) : cusBodyStyle(14),
                ),
              ),
            ),
        ],
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  SizedBox buildProductCatalog() {
    return SizedBox(
      child: StreamBuilder<List<String>>(
        stream: categoryProductsStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<String> productsId = snapshot.data;
            if (productsId.length == 0) {
              return Container(
                height: SizeConfig.screenHeight * 0.5,
                child: Center(
                  child: NothingToShowContainer(
                    secondaryMessage: widget.productType == null ? "No Products to show." : "No Products in ${EnumToString.convertToString(widget.productType)}",
                  ),
                ),
              );
            }
            return buildProductsGrid(productsId);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error;
            Logger().w(error.toString());
          }
          return Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/network_error.svg",
              primaryMessage: "Something went wrong",
              secondaryMessage: "Unable to connect to Database",
            ),
          );
        },
      ),
    );
  }

  Widget buildHeadBar() {
    return SizedBox(
      height: getProportionateScreenHeight(22),
      child: Row(
        children: [
          Container(
            height: getProportionateScreenHeight(40),
            child: RoundedIconButton(
              iconData: Icons.arrow_back_ios_rounded,
              press: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(width: 10),
          // Expanded(
          //   child: SearchField(
          //     onSubmit: (value) async {
          //       final query = value.toString();
          //       if (query.length <= 0) return;
          //       List<String> searchedProductsId;
          //       try {
          //         searchedProductsId = await ProductDatabaseHelper().searchInProducts(query.toLowerCase(), productType: widget.productType);
          //         if (searchedProductsId != null) {
          //           await Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => SearchResultScreen(
          //                 searchQuery: query,
          //                 searchResultProductsId: searchedProductsId,
          //                 searchIn: EnumToString.convertToString(widget.productType),
          //               ),
          //             ),
          //           );
          //           await refreshPage();
          //         } else {
          //           throw "Couldn't perform search due to some unknown reason";
          //         }
          //       } catch (e) {
          //         final error = e.toString();
          //         Logger().e(error);
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(
          //             content: Text("$error"),
          //           ),
          //         );
          //       }
          //     },
          //   ),
          // ),

          // Category Selector
          Expanded(
            // flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  elevation: 1,
                  dropdownColor: Colors.white,
                  hint: _categoryName == null
                      ? Text('Dropdown')
                      : Text(
                          _categoryName,
                          style: cusHeadingStyle(getProportionateScreenHeight(20), kPrimaryColor),
                        ),
                  // isExpanded: true,
                  iconSize: getProportionateScreenHeight(20),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: kPrimaryColor,
                  ),
                  style: TextStyle(color: kPrimaryColor),
                  items: _categoryList.map(
                    (val) {
                      return DropdownMenuItem<String>(
                        value: val[0],
                        child: Text(
                          val[1],
                          style: cusHeadingLinkStyle,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(() {
                      fetchCategoryWithTypeName(val);
                      _categoryName = category["title"];
                      // _categoryName == "All Products"
                      // ? _subCatList = ["Sports Nutrition", "Vitamin/Supplement", "Health Food & Drink", "Clothing Apparel", "Explore Fitness"]
                      fetchSubCategories(_categoryName);
                      reInitProductStream();
                      _selectedSubCat = "";
                      // buildProductCatalog();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshPage() {
    reInitProductStream();
    return Future<void>.value();
  }

  reInitProductStream([String selectedSubCat, String searchString]) {
    categoryProductsStream.dispose();
    widget.productType = category["product_type"];
    categoryProductsStream = CategoryProductsStream(widget.productType, selectedSubCat ?? null, searchString ?? null);
    // print(categoryProductsStream.stream.first);
    categoryProductsStream.init();

    // print(categoryProductsStream.category);
  }

  // Widget buildCategoryBanner() {
  //   return Stack(
  //     children: [
  //       Container(
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: AssetImage(bannerFromProductType()),
  //             fit: BoxFit.fill,
  //             colorFilter: ColorFilter.mode(
  //               kPrimaryColor,
  //               BlendMode.hue,
  //             ),
  //           ),
  //           borderRadius: BorderRadius.circular(30),
  //         ),
  //       ),
  //       Align(
  //         alignment: Alignment.centerLeft,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 16),
  //           child: Text(
  //             EnumToString.convertToString(widget.productType),
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w900,
  //               fontSize: 24,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget buildProductsGrid(List<String> productsId) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        // color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: productsId.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            child: ProductCard(
              productId: productsId[index],
              noSpacing: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      productId: productsId[index],
                    ),
                  ),
                ).then(
                  (_) async {
                    await refreshPage();
                  },
                );
              },
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.84,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        padding: EdgeInsets.symmetric(
          // horizontal: 4,
          vertical: 12,
        ),
      ),
    );
  }

  // String bannerFromProductType() {
  //   switch (widget.productType) {
  //     case ProductType.Nutrition:
  //       return "assets/images/electronics_banner.jpg";
  //     case ProductType.Supplements:
  //       return "assets/images/books_banner.jpg";
  //     case ProductType.Food:
  //       return "assets/images/fashions_banner.jpg";
  //     case ProductType.Clothing:
  //       return "assets/images/groceries_banner.jpg";
  //     case ProductType.Explore:
  //       return "assets/images/arts_banner.jpg";
  //     // case ProductType.Others:
  //     //   return "assets/images/others_banner.jpg";
  //     default:
  //       return "assets/images/others_banner.jpg";
  //   }
  // }

  // ProductType nameToProductType() {
  //   switch (_category) {
  //     case "Nutrition":
  //       return ProductType.Nutrition;
  //     case "Supplements":
  //       return ProductType.Supplements;
  //     case "Food":
  //       return ProductType.Food;
  //     case "Clothing":
  //       return ProductType.Clothing;
  //     case "Explore":
  //       return ProductType.Explore;
  //     // case ProductType.Others:
  //     //   return "assets/images/others_banner.jpg";
  //     default:
  //       return ProductType.Nutrition;
  //   }
  // }
  //
  String fetchTypeNameWithName(String name) {
    switch (name) {
      case "Sports Nutrition":
        return "Nutrition";
      case "Vitamin/Supplement":
        return "Supplements";
      case "Health Food & Drink":
        return "Food";
      case "Clothing Apparel":
        return "Clothing";
      case "Explore Fitness":
        return "Explore";
      default:
        return "";
    }
  }

  fetchCategoryWithTypeName(String typeName) {
    // print(name == "All" ? "Wow" : "");
    category = (typeName == "All")
        ? {"title": "All Products"}
        : widget.productTypes.where((type) => EnumToString.convertToString(type["product_type"]) == typeName).first;
  }

  fetchSubCategories(String cat) {
    PdctSubCategories.forEach((key, value) {
      if (cat == key) _subCatList = value;
    });
  }
}
