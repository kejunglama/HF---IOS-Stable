import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthfix/models/Gym.dart';
import 'package:healthfix/models/Meal.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';

class MealsDatabaseHelper {
  static const String MEALS_COLLECTION_NAME = "meals";
  // static const String TRAINERS_COLLECTION_NAME = "trainers";

  static const String NAME_KEY = "display_picture";
  static const String OPENING_TIME_KEY = "opening_time";
  static const String LOCATION_KEY = "location";
  static const String LOCATION_NAME_KEY = "address";
  static const String LOCATION_LINK_KEY = "map_link";
  static const String PACKAGES_KEY = "packages";
  static const String PACKAGES_DURATION_KEY = "duration";
  static const String PACKAGES_PRICE_KEY = "price";

  MealsDatabaseHelper._privateConstructor();

  static MealsDatabaseHelper _instance =
      MealsDatabaseHelper._privateConstructor();

  factory MealsDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;

  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<void> createNewGym(String uid) async {
    await firestore.collection(MEALS_COLLECTION_NAME).doc(uid).set({
      NAME_KEY: null,
      OPENING_TIME_KEY: null,
      LOCATION_KEY: [],
      PACKAGES_KEY: {},
    });
  }

  // Future<void> deleteCurrentGymData() async {
  //   final uid = AuthentificationService().currentUser.uid;
  //   final docRef = firestore.collection(MEALS_COLLECTION_NAME).doc(uid);

  //   await docRef.delete();
  // }

  Stream<DocumentSnapshot> get currentMealsDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore
        .collection(MEALS_COLLECTION_NAME)
        .doc(uid)
        .get()
        .asStream();
  }

  Future<List<String>> get mealsList async {
    final productsCollectionReference =
        firestore.collection(MEALS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference.get();
    List<String> meals = [];
    querySnapshot.docs.forEach((doc) {
      meals.add(doc.id);
    });
    return meals;
  }

  Future<Meal> getMealsWithID(String mealId) async {
    final docSnapshot =
        await firestore.collection(MEALS_COLLECTION_NAME).doc(mealId).get();
    if (docSnapshot.exists) {
      var meal = Meal.fromMap(docSnapshot.data(), id: docSnapshot.id);
      return meal;
    }
    return null;
  }
}
