import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/meals_database_helper.dart';
// import 'package:healthfix/services/database/product_database_helper.dart';

class MealsStream extends DataStream<List<String>> {
  @override
  void reload() {
    Future MealsFuture = MealsDatabaseHelper().mealsList;

    MealsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}

class MealsSearchStream extends DataStream<List<Meal>> {
  String searchString;

  MealsSearchStream({this.searchString});

  @override
  void reload() {
    Future<List<Meal>> MealsFuture;
    print("object");
    if (searchString != null) {
      if (searchString.isNotEmpty) {
        MealsFuture = MealsDatabaseHelper().searchInMeals(searchString);
      }
    } else {
      return;
      // MealsFuture = MealsDatabaseHelper().mealsList;
    }
    if (MealsFuture != null)
      MealsFuture.then((favProducts) {
        addData(favProducts);
      }).catchError((e) {
        addError(e);
      });
  }
}
