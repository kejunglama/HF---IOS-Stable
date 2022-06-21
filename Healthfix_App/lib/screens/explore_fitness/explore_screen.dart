import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/data.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/category_products/category_products_screen.dart';
import 'package:healthfix/screens/healthy_meals/healthy_meals_screen.dart';
// import 'package:healthfix/screens/healthy_meals/healthy_meals_screen.dart';
import 'package:healthfix/size_config.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen();

  final List imageFileName = [
    "Banner Image - Healthy Meals.jpeg",
    "Banner Image - Fitness Wears.jpeg",
    "Banner Image - Gym.jpeg",
    "Banner Image - Diet Consultation.png",
    "Banner Image - Home Workout.jpeg",
  ];

  final List captionList = [
    "Healthy Meals",
    "Fitness Wears Ecommerce",
    "Membership in Kathmandu's Best Gyms",
    "Diet Plan, Personal Training, Workout Programs",
    "Online Fitness Classes",
  ];

  final List titleList = [
    "Healthy Meals",
    "Fitness Wears",
    "Gym Membership",
    "Trainer/Consultation",
    "Fitness Classes",
  ];

  final List toScreen = [
    HealthyMealsScreen(),
    CategoryProductsScreen(
      productType: ProductType.All,
      productTypes: pdctCategories,
      subProductType: "",
    ),
    null,
    null,
    null,
    // HomeScreen(),
    // HomeScreen(),
    // HomeScreen(),
    // HomeScreen(),
    // GymMembershipScreen(),
    // GymMembershipScreen(),
    // FitnessTrainerDetailsScreen(),
    // FitnessTrainersScreen(),
    // GymMembershipScreen(),
    // GymMembershipScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   // appBar: AppBar(),
    //   body: SafeArea(
    //     child: Column(
    //       // crossAxisAlignment: CrossAxisAlignment.end,
    //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.all(getProportionateScreenHeight(20)),
    //           child: Text(
    //             "Explore Fitness with Healthfix",
    //             style: cusCenterHeadingStyle(),
    //           ),
    //         ),
    //         for (var i = 0; i < 3; i++)
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: ExploreCard(
    //                 imageURL: imageList[i],
    //                 color: colors[i],
    //                 caption: captionList[i],
    //                 text: textList[i]),
    //           ),
    //       ],
    //     ),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("Explore Fitness with Healthfix",
            style: cusCenterHeadingStyle(Colors.white)),
        backgroundColor: kPrimaryColor.withOpacity(0.9),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: getProportionateScreenHeight(16)),
          child: GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 6 / 3,
            mainAxisSpacing: getProportionateScreenHeight(16),
            children: List.generate(
              titleList.length,
              (i) => ExploreCard(
                imageFileName: imageFileName[i],
                caption: captionList[i],
                text: titleList[i],
                toScreen: toScreen[i],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExploreCard extends StatelessWidget {
  ExploreCard({
    Key key,
    @required this.imageFileName,
    this.color,
    @required this.caption,
    @required this.text,
    @required this.toScreen,
  }) : super(key: key);

  final String imageFileName;
  final Color color;
  final String caption;
  final String text;
  final Widget toScreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toScreen != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => toScreen),
              );
            }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Feature will be added soon!"),
                ),
              );
            },
      child: Opacity(
        opacity: toScreen != null ? 1 : 0.6,
        child: Container(
          width: SizeConfig.screenWidth,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(16)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue,
                Colors.black,
              ],
            ),
            image: DecorationImage(
              image: AssetImage("assets/images/explore/$imageFileName"),
              fit: BoxFit.cover,
              // colorFilter: ColorFilter.mode(color, BlendMode.colorBurn),
              opacity: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        bottom: getProportionateScreenHeight(8)),
                    child: Text(
                      text,
                      maxLines: 1,
                      style: cusHeadingStyle(
                        fontSize: getProportionateScreenHeight(20),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // SizedBox(height: getProportionateScreenHeight()),
                  Text(
                    caption,
                    maxLines: 2,
                    style: cusBodyStyle(
                        fontSize: getProportionateScreenHeight(14),
                        color: Colors.white),
                  ),
                  // SizedBox(height: getProportionateScreenHeight(8)),
                  // cusButton(text: "Learn More"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class cusButton extends StatelessWidget {
  final String text;

  cusButton({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                // height: 30,
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                primary: Colors.white,
                // fixedSize: ,
                // textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {},
              child: Text(
                text ?? 'Learn More',
                style: cusHeadingStyle(
                    fontSize: getProportionateScreenHeight(16),
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
