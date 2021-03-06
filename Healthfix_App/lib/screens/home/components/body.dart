import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/cart/cart_screen.dart';
import 'package:healthfix/screens/category_products/category_products_screen.dart';
import 'package:healthfix/screens/home/components/DietPlannerBanner.dart';
import 'package:healthfix/screens/home/components/our_feature_section.dart';
import 'package:healthfix/screens/home/components/product_categories.dart';
import 'package:healthfix/screens/home/components/top_brands_section.dart';
import 'package:healthfix/screens/product_details/product_details_screen.dart';
import 'package:healthfix/screens/search_result/search_result_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/data_streams/all_products_stream.dart';
// import 'package:healthfix/services/data_streams/favourite_products_stream.dart';
import 'package:healthfix/services/data_streams/featured_products_stream.dart';
import 'package:healthfix/services/data_streams/flash_sales_products_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';
import 'package:new_version/new_version.dart';

import '../../../utils.dart';
import '../components/home_header.dart';
import 'home_ads_banner.dart';
import 'home_ongoing_offers.dart';
import 'products_section.dart';

class Body extends StatefulWidget {
  final void Function() goToCategory;
  // final void Function() showNotification;

  Body(this.goToCategory);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<String> adsBannerImagesList = [
    'assets/banners/Swanson - Launch Offer.png',
    'assets/banners/Feature Banner - Skullcandy.png',
    'assets/banners/Feature Banner - True Elements.png',
  ];

  final List adsBannerNavigation = [
    CategoryProductsScreen(
      productType: ProductType.Supplements,
      productTypes: pdctCategories,
      subProductType: "",
      searchString: "swanson",
    ),
    CategoryProductsScreen(
      productType: ProductType.Supplements,
      productTypes: pdctCategories,
      subProductType: "",
      searchString: "skullcandy",
    ),
    CategoryProductsScreen(
      productType: ProductType.Supplements,
      productTypes: pdctCategories,
      subProductType: "",
      searchString: "true elements",
    ),
  ];

  final List<String> offerImagesList = [
    'https://i.pinimg.com/originals/a2/af/48/a2af4856f5bc2272554efa4f19502ebf.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/black-gym-discount-instagram-post-template-design-4fd8234005349d24e1e91fb6ce152158_screen.jpg?ts=1561443287',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9QSlHbGPoLRbf3XbCpDbtOMKP3_blu9IZQAFlx2YbMIiT7uuIqMVIZMyhFbrful948RE&usqp=CAU',
  ];

  // final List<String> topCategoriesList = [
  //   'https://firebasestorage.googleapis.com/v0/b/siteux-healthfix.appspot.com/o/top_categories%2FTOPCAT-2.png?alt=media&token=a6b3e4d0-2374-4dcb-80e0-03e52545f8ab',
  //   'https://firebasestorage.googleapis.com/v0/b/siteux-healthfix.appspot.com/o/top_categories%2FTOPCAT-1.png?alt=media&token=e9c7c16c-2899-4f1a-a0d3-407436f9e586',
  // ];

  final List<String> topBrandsList = [
    'https://firebasestorage.googleapis.com/v0/b/siteux-healthfix.appspot.com/o/logos%2Flogo-fitcal.jpg?alt=media&token=a3e9d47f-4b12-4614-bb90-83b7d0605a64',
    'https://media.designrush.com/inspiration_images/134805/conversions/_1512076803_93_Nike-preview.jpg',
    'https://image.shutterstock.com/image-photo/kiev-ukraine-march-31-2015-260nw-275940803.jpg',
    'https://cdn.shopify.com/s/files/1/1367/5207/files/gymshark_social_banner_1200x1200.jpg?v=1549554503',
    'https://1000logos.net/wp-content/uploads/2020/09/Optimum-Nutrition-Logo.png',
    'https://1000logos.net/wp-content/uploads/2021/05/Skullcandy-logo.png',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Reebok_2019_logo.svg/1200px-Reebok_2019_logo.svg.png',
  ];

  final String dietPlanBanner = "assets/banners/Fresh Healthy Meal.png";

  // final FavouriteProductsStream favouriteProductsStream =
  // FavouriteProductsStream();
  final SomeProductsStream someProductsStream = SomeProductsStream();
  final FeaturedProductsStream featuredProductsStream = FeaturedProductsStream();
  final FlashSalesProductsStream flashSalesProductsStream = FlashSalesProductsStream();

  @override
  void initState() {
    super.initState();
    // favouriteProductsStream.init();
    someProductsStream.init();
    featuredProductsStream.init();
    flashSalesProductsStream.init();
    checkNewVersion();
  }

  @override
  void dispose() {
    // favouriteProductsStream.dispose();
    // allProductsStream.dispose();
    // featuredProductsStream.dispose();
    // flashSalesProductsStream.dispose();
    super.dispose();
  }

  void checkNewVersion() async {
    final newVersion = NewVersion(
      androidId: "com.siteux.healthfix",
    );
    final status = await newVersion.getVersionStatus();
    if (status.storeVersion != status.localVersion)
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: "New Update Available!",
        dismissButtonText: "LATER",
        dialogText: "A New Version of Helathfix App is Available on Play/App Store. \n"
            "\nAvailable Version: ${status.storeVersion}"
            "\nVersion Installed: ${status.localVersion} ",
        updateButtonText: "UPDATE",
      );

    print("DEVICE : " + status.localVersion);
    print("STORE : " + status.storeVersion);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Section - Home Header
            HomeHeader(
              // showNotification: widget.showNotification,
              onSearchSubmitted: (value) async {
                final query = value.toString();
                if (query.length <= 0) return;
                List<String> searchedProductsId;
                try {
                  searchedProductsId = await ProductDatabaseHelper().searchInProducts(query.toLowerCase());
                  if (searchedProductsId != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                          searchQuery: query,
                          searchResultProductsId: searchedProductsId,
                          searchIn: "All Products",
                        ),
                      ),
                    );
                    await refreshPage();
                  } else {
                    throw "Couldn't perform search due to some unknown reason";
                  }
                } catch (e) {
                  final error = e.toString();
                  Logger().e(error);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$error"),
                    ),
                  );
                }
              },
              onCartButtonPressed: () async {
                bool allowed = AuthentificationService().currentUserVerified;
                if (!allowed) {
                  final reVerify = await showConfirmationDialog(context,
                      "You haven't verified your email address. This action is only allowed for verified users.",
                      positiveResponse: "Resend verification email", negativeResponse: "Go back");
                  if (reVerify) {
                    final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return FutureProgressDialog(
                          future,
                          message: Text("Resending verification email"),
                        );
                      },
                    );
                  }
                  return;
                }
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
                await refreshPage();
              },
            ),

            sizedBoxOfHeight(12),

            // Section - Offer Banners
            AdsBanners(adsBannerImagesList, adsBannerNavigation),

            sizedBoxOfHeight(5),

            // Section - Product Category
            ProductCategories(widget.goToCategory),

            // SizedBox(height: getProportionateScreenHeight(20)),
            // SizedBox(
            //   height: SizeConfig.screenHeight * 0.5,
            //   child: ProductsSection(
            //     sectionTitle: "Products You Like",
            //     productsStreamController: favouriteProductsStream,
            //     emptyListMessage: "Add Product to Favourites",
            //     onProductCardTapped: onProductCardTapped,
            //   ),
            // ),
            // SizedBox(height: getProportionateScreenHeight(20)),

            // Section - Flash Sales
            flashSalesProducts(),

            // Section - Diet Plan Banner
            MealsBanner(dietPlanBanner),

            // Section - Explore Products
            exploreProducts(),

            // Section - Ongoing Offers
            OngoingOffers(offerImagesList),

            // Section - Trending Products
            trendingProducts(),

            // Top categories
            // Container(
            //   color: kPrimaryColor.withOpacity(0.1),
            //   child: Column(
            //     children: [
            //       SizedBox(height: getProportionateScreenHeight(12)),
            //       Text(
            //         "Top Categories",
            //         style: cusCenterHeadingStyle(),
            //       ),
            //       // SizedBox(height: getProportionateScreenHeight(10)),
            //
            //       // SizedBox(
            //       //   height: 532,
            //       //   child: GridView.count(
            //       //     crossAxisCount: 2,
            //       //     children: List.generate(
            //       //       4,
            //       //       (index) => Container(
            //       //         height: 100,
            //       //         child: TopCategoryCard(),
            //       //       ),
            //       //     ),
            //       //   ),
            //       // ),
            //       Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           SizedBox(height: getProportionateScreenHeight(20)),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               TopCategoryCard(topCategoriesList[0]),
            //               SizedBox(width: getProportionateScreenWidth(20)),
            //               TopCategoryCard(topCategoriesList[1]),
            //             ],
            //           ),
            //           SizedBox(height: getProportionateScreenHeight(20)),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               TopCategoryCard(topCategoriesList[1]),
            //               SizedBox(width: getProportionateScreenWidth(20)),
            //               TopCategoryCard(topCategoriesList[0]),
            //             ],
            //           ),
            //           SizedBox(height: getProportionateScreenHeight(20)),
            //         ],
            //       )
            //     ],
            //   ),
            // ),

            // Section - Top Brands
            TopBrandsSection(topBrandsList),

            // Section - Our Features
            OurFeaturesSection(),
          ],
        ),
      ),
      // ),
    );
  }

  Container trendingProducts() {
    return Container(
      // height: getProportionateScreenHeight(280),
      child: ProductsSection(
        sectionTitle: "Trending Products",
        productsStreamController: featuredProductsStream,
        emptyListMessage: "Looks like all Stores are closed",
        onProductCardTapped: onProductCardTapped,
      ),
    );
  }

  Container flashSalesProducts() {
    return Container(
      height: getProportionateScreenHeight(280),
      child: ProductsSection(
        sectionTitle: "Flash Sales",
        productsStreamController: flashSalesProductsStream,
        emptyListMessage: "Looks like all Stores are closed",
        onProductCardTapped: onProductCardTapped,
        // onSeeMorePress: () {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => OfferProductsScreen(),
        //     ),
        //   );
        // },
      ),
    );
  }

  Container exploreProducts() {
    return Container(
      height: getProportionateScreenHeight(280),
      child: ProductsSection(
        sectionTitle: "Explore All Products",
        productsStreamController: someProductsStream,
        emptyListMessage: "Looks like all Stores are closed",
        onProductCardTapped: onProductCardTapped,
        onSeeMorePress: () {
          print("BOOBOBOB");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryProductsScreen(
                productType: ProductType.All,
                productTypes: pdctCategories,
                subProductType: "",
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> refreshPage() {
    // favouriteProductsStream.reload();
    someProductsStream.reload();
    featuredProductsStream.reload();
    flashSalesProductsStream.reload();
    return Future<void>.value();
  }

  void onProductCardTapped(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productId: productId),
      ),
    ).then((_) async {
      await refreshPage();
    });
  }
}
