import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/screens/healthy_meal_description/healthy_meal_desc_screen.dart';
// import 'package:healthfix/screens/healthy_meals/healthy_meals_screen.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:healthfix/services/data_streams/all_meals_stream.dart';
import 'package:healthfix/services/database/meals_database_helper.dart';
import 'package:healthfix/size_config.dart';
// import 'package:healthfix/services/database/meals_database_helper.dart';
import 'package:logger/logger.dart';

import '../../../components/nothingtoshow_container.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  AllMealsStream mealsStream = AllMealsStream();

  void initState() {
    mealsStream.init();
    super.initState();
  }

  @override
  void dispose() {
    mealsStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: kPrimaryColor.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text("Healthy Meals",
                //     style: cusHeadingStyle(getProportionateScreenHeight(28))),
                // Text("What do you want to find",
                //     style: cusHeadingStyle(null, null, null, FontWeight.w300)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      // "https://psdfree.net/wp-content/uploads/2021/08/10x.jpg",
                      "https://image.shutterstock.com/image-vector/delicious-hamburger-fries-banner-ads-260nw-1203026587.jpg"),
                ),
                sizedBoxOfHeight(20),
                buildPopularMeals(),
                buildOurMeals(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPopularMeals() {
    List featuredMealsIds = [
      "fa66ef10-e6e2-11ec-a59d-f1527b8d2e37",
      "fa859aa0-e6e2-11ec-a59d-f1527b8d2e37",
      "fa98d480-e6e2-11ec-a59d-f1527b8d2e37",
    ];

    List<Widget> featuredCardsHori = [];
    featuredCardsHori.add(
      FutureBuilder<Meal>(
          future: MealsDatabaseHelper().getMealsWithID(featuredMealsIds.first),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildMealCardVertical(
                  // imageSize: getProportionateScreenHeight(60),
                  // titleFontSize: getProportionateScreenHeight(14),
                  meal: snapshot.data);
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              Logger().w(error.toString());
              return Center(
                child: Text(error.toString()),
              );
            } else {
              return Center(child: Icon(Icons.error));
            }
          }),
    );

    for (var featuredMealId in featuredMealsIds.sublist(1)) {
      featuredCardsHori.add(
        FutureBuilder<Meal>(
            future: MealsDatabaseHelper().getMealsWithID(featuredMealId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return buildMealCardHorizontal(
                    imageSize: getProportionateScreenHeight(60),
                    titleFontSize: getProportionateScreenHeight(14),
                    meal: snapshot.data);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                final error = snapshot.error;
                Logger().w(error.toString());
                return Center(
                  child: Text(error.toString()),
                );
              } else {
                return Center(child: Icon(Icons.error));
              }
            }),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Popular",
                style: cusHeadingStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontWeight: FontWeight.w400)),
            Text("See All", style: cusHeadingLinkStyle),
          ],
        ),
        sizedBoxOfHeight(20),
        SizedBox(
          // width: (SizeConfig.screenWidth - getProportionateScreenWidth(20)) / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // spacing: getProportionateScreenWidth(12),
            children: [
              SizedBox(
                child: featuredCardsHori.first,
                width: getProportionateScreenWidth(140),
                height: getProportionateScreenHeight(244),
              ),
              sizedBoxOfWidth(8),
              Expanded(
                child: SizedBox(
                  height: getProportionateScreenHeight(244),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: featuredCardsHori.sublist(1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMealCardHorizontal(
      {num imageSize, double titleFontSize, Meal meal}) {
    // print(meal);
    return Container(
      // width: SizeConfig.screenWidth - 2 * getProportionateScreenWidth(20),
      // height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(getProportionateScreenHeight(12)),
      child: Row(
        children: [
          Container(
            height: imageSize ?? getProportionateScreenHeight(120),
            width: imageSize ?? getProportionateScreenHeight(120),
            // padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            child: Image.network(meal != null
                ? meal.images.first
                : "https://fitcal.com.np/wp-content/uploads/2022/03/Chicken-Breast-768x768.png"),
          ),
          sizedBoxOfWidth(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  meal != null ? meal.title : "Stir Brown Rice",
                  style: cusHeadingStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                sizedBoxOfHeight(8),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            getProportionateScreenHeight(30)),
                        color: kPrimaryColor.withOpacity(0.2),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(8),
                          vertical: getProportionateScreenHeight(4)),
                      // Meal Portion
                      child: Text(
                        "1 Meal",
                        style: cusBodyStyle(
                            fontSize: getProportionateScreenHeight(12),
                            fontWeight: FontWeight.w500,
                            color: kPrimaryColor),
                      ),
                    ),
                    sizedBoxOfWidth(12),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 238, 222, 83),
                          size: getProportionateScreenHeight(20),
                        ),
                        // Ratings
                        Text(
                          "4.9",
                          style: cusBodyStyle(
                              fontSize: getProportionateScreenHeight(12)),
                        ),
                      ],
                    ),
                  ],
                ),
                sizedBoxOfHeight(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                        meal != null
                            ? currency.format(meal.originalPrice)
                            : "Rs. 200",
                        style: cusPdctDisPriceStyle(
                            getProportionateScreenHeight(16))),
                    // Add to Cart Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            getProportionateScreenHeight(30)),
                        color: kPrimaryColor,
                      ),
                      height: getProportionateScreenHeight(30),
                      width: getProportionateScreenHeight(30),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: getProportionateScreenHeight(20),
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMealCardVertical({Meal meal}) {
    return Container(
      // width: SizeConfig.screenWidth - 2 * getProportionateScreenWidth(20),
      // height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.all(getProportionateScreenHeight(12)),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              meal != null ? meal.title : "Stir Brown Rice",
              style: cusHeadingStyle(
                  fontSize: getProportionateScreenHeight(16),
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            // sizedBoxOfHeight(8),
            Container(
              height: getProportionateScreenHeight(120),
              width: getProportionateScreenHeight(120),
              // padding: EdgeInsets.all(getProportionateScreenWidth(8)),
              child: Image.network(meal != null
                  ? meal.images.first
                  : "https://fitcal.com.np/wp-content/uploads/2022/03/Chicken-Breast-768x768.png"),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(getProportionateScreenHeight(30)),
                    color: kPrimaryColor.withOpacity(0.2),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(8),
                      vertical: getProportionateScreenHeight(4)),
                  // Meal Portion
                  child: Text(
                    "1 Meal",
                    style: cusBodyStyle(
                        fontSize: getProportionateScreenHeight(12),
                        fontWeight: FontWeight.w500,
                        color: kPrimaryColor),
                  ),
                ),
                sizedBoxOfWidth(12),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 238, 222, 83),
                      size: getProportionateScreenHeight(20),
                    ),
                    // Ratings
                    Text(
                      "4.9",
                      style: cusBodyStyle(
                          fontSize: getProportionateScreenHeight(12)),
                    ),
                  ],
                ),
              ],
            ),
            // sizedBoxOfHeight(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Text(
                    meal != null
                        ? currency.format(meal.originalPrice)
                        : "Rs. 200",
                    style:
                        cusPdctDisPriceStyle(getProportionateScreenHeight(16))),
                // Add to Cart Button
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(getProportionateScreenHeight(30)),
                    color: kPrimaryColor,
                  ),
                  height: getProportionateScreenHeight(30),
                  width: getProportionateScreenHeight(30),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: getProportionateScreenHeight(20),
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOurMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBoxOfHeight(28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Our Meals",
                style: cusHeadingStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontWeight: FontWeight.w400)),
            Text("See All", style: cusHeadingLinkStyle),
          ],
        ),
        sizedBoxOfHeight(20),
        StreamBuilder(
          stream: mealsStream.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List mealIds = snapshot.data;
              // String mealId = snapshot.data[0];
              List<Widget> temp = [];
              for (String mealId in mealIds) {
                Future<Meal> mealFuture =
                    MealsDatabaseHelper().getMealsWithID(mealId);
                temp.add(InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthyMealDescScreen(mealId),
                        ),
                      );
                    },
                    child: SizedBox(
                        height: getProportionateScreenHeight(160),
                        child: Column(
                          children: [
                            FutureBuilder<Meal>(
                                future: mealFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return buildMealCardHorizontal(
                                        meal: snapshot.data);
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    final error = snapshot.error;
                                    Logger().w(error.toString());
                                    return Center(
                                      child: Text(
                                        error.toString(),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Icon(
                                        Icons.error,
                                      ),
                                    );
                                  }
                                }),
                            sizedBoxOfHeight(10),
                          ],
                        ))));
              }
              return Column(
                children: temp,
              );
              // for (String mealId in mealIds) {
              //   InkWell(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => HealthyMealDescScreen(mealId),
              //           ),
              //         );
              //       },
              //       child: SizedBox(
              //           height: getProportionateScreenHeight(180),
              //           child: Column(
              //             children: [
              //               buildMealCardHorizontal(),
              //               sizedBoxOfHeight(10),
              //             ],
              //           )));
              // }
              //   print(snapshot.data);
              //   return InkWell(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => HealthyMealDescScreen(mealId),
              //           ),
              //         );
              //       },
              //       child: SizedBox(
              //           height: getProportionateScreenHeight(180),
              //           child: Column(
              //             children: [
              //               buildMealCardHorizontal(),
              //               sizedBoxOfHeight(10),
              //             ],
              //           )));
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
      ],
    );
  }
}
