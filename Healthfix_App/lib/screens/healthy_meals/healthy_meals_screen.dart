import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/screens/healthy_meal_description/healthy_meal_desc_screen.dart';
import 'package:healthfix/screens/healthy_meals/components/body.dart';
// import 'package:healthfix/screens/healthy_meals_search/healthy_meals_search_screen.dart';
import 'package:healthfix/services/data_streams/all_meals_stream.dart';
import 'package:healthfix/size_config.dart';

class HealthyMealsScreen extends StatefulWidget {
  const HealthyMealsScreen({Key key}) : super(key: key);
  @override
  State<HealthyMealsScreen> createState() => _HealthyMealsScreenState();
}

class _HealthyMealsScreenState extends State<HealthyMealsScreen> {
  MealsStream mealsStream = MealsStream();
  MealsSearchStream mealsSearchStream = MealsSearchStream(searchString: "sand");

  Icon seachIcon = const Icon(Icons.search);
  Color searchBarColor = kPrimaryColor.withOpacity(0.05);
  Widget searchBarWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Fitcal ",
          style: cusHeadingStyle(
              fontSize: getProportionateScreenHeight(20), color: Colors.purple, fontWeight: FontWeight.w500)),
      Text("Meals", style: cusHeadingStyle(fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.w300)),
    ],
  );
  Widget bodyWidget = Body();
  bool showSearchResultWidget = false;
  String searchText;
  Color iconColor;

  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();
    mealsStream.init();
    mealsSearchStream.init();
    fetchSearchData();
  }

  void fetchSearchData() {
    mealsSearchStream.stream.listen((data) {
      setState(() {
        meals = data;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    mealsStream.dispose();
    mealsSearchStream.dispose();
  }

  reInitMealsSearchStream(String searchString) {
    mealsSearchStream.dispose();
    mealsSearchStream = MealsSearchStream(searchString: searchString);
    mealsSearchStream.init();
    fetchSearchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBarWidget,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: iconColor ?? Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (seachIcon.icon == Icons.search) {
                  // Searching
                  seachIcon = const Icon(Icons.cancel, color: Colors.white);
                  searchBarColor = kPrimaryColor;
                  iconColor = Colors.white;
                  searchBarWidget = ListTile(
                    title: TextFormField(
                        initialValue: searchText,
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,
                        style: cusHeadingStyle(
                            fontSize: getProportionateScreenHeight(14),
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                        decoration: InputDecoration(
                          fillColor: kPrimaryColor.withOpacity(0.9),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                          hintText: "Search Healthy Meals",
                          hintStyle: cusHeadingStyle(
                              fontSize: getProportionateScreenHeight(14),
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                          // prefixIcon: Icon(
                          //   Icons.search_rounded,
                          //   color: Colors.white,
                          //   size: getProportionateScreenHeight(24),
                          // ),
                          contentPadding: EdgeInsets.all(getProportionateScreenHeight(10)),
                        ),
                        // onSubmitted: onSubmit,
                        onChanged: (String _searchText) {
                          setState(() {
                            searchText = _searchText;
                          });
                          reInitMealsSearchStream(_searchText);
                        }),
                  );
                  showSearchResultWidget = true;
                } else {
                  seachIcon = const Icon(Icons.search);
                  searchBarColor = kPrimaryColor.withOpacity(0.05);
                  iconColor = Colors.black;
                  searchBarWidget = Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Fitcal ",
                          style: cusHeadingStyle(
                              fontSize: getProportionateScreenHeight(20),
                              color: Colors.purple,
                              fontWeight: FontWeight.w500)),
                      Text("Meals",
                          style:
                              cusHeadingStyle(fontSize: getProportionateScreenHeight(20), fontWeight: FontWeight.w300)),
                    ],
                  );
                  showSearchResultWidget = false;
                }
              });
            },
            icon: Padding(
              padding: EdgeInsets.all(getProportionateScreenHeight(8)),
              child: seachIcon,
            ),
          ),
        ],
        backgroundColor: searchBarColor,
      ),
      body: Stack(
        children: [
          Visibility(visible: showSearchResultWidget, child: buildSearchResult()),
          Visibility(visible: !showSearchResultWidget, child: Body()),
        ],
      ),
    );
  }

  Widget buildSearchResult() {
    return Visibility(
      visible: showSearchResultWidget,
      child: Container(
        child: meals.length > 0
            ? SingleChildScrollView(
                child: Column(children: meals.map((meal) => buildMealCard(meal)).toList()),
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: getProportionateScreenHeight(100),
                    color: Colors.grey,
                  ),
                  Text(
                    "No Meals Found",
                    style: cusHeadingStyle(color: Colors.grey),
                  ),
                  Text(
                    "Your search did not match any meals.\nPlease try again.",
                    style: cusBodyStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
      ),
    );
  }

  Widget buildMealCard(Meal meal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HealthyMealDescScreen(null, meal: meal),
            ));
      },
      child: Container(
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
              height: getProportionateScreenHeight(120),
              width: getProportionateScreenHeight(120),
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
                    style: cusHeadingStyle(fontSize: getProportionateScreenHeight(14), fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  sizedBoxOfHeight(8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(getProportionateScreenHeight(30)),
                          color: kPrimaryColor.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(8), vertical: getProportionateScreenHeight(4)),
                        // Meal Portion
                        child: Text(
                          "1 Meal",
                          style: cusBodyStyle(
                              fontSize: getProportionateScreenHeight(10),
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
                            style: cusBodyStyle(fontSize: getProportionateScreenHeight(12)),
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
                      Text(meal != null ? currency.format(meal.originalPrice) : "Rs. 200",
                          style: cusPdctDisPriceStyle(getProportionateScreenHeight(14))),
                      // Add to Cart Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(getProportionateScreenHeight(30)),
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
      ),
    );
  }
}
