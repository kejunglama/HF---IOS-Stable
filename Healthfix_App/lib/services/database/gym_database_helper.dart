import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthfix/models/Gym.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';

class GymDatabaseHelper {
  static const String GYMS_COLLECTION_NAME = "gym";
  static const String TRAINERS_COLLECTION_NAME = "trainers";

  static const String NAME_KEY = "display_picture";
  static const String OPENING_TIME_KEY = "opening_time";
  static const String LOCATION_KEY = "location";
  static const String LOCATION_NAME_KEY = "address";
  static const String LOCATION_LINK_KEY = "map_link";
  static const String PACKAGES_KEY = "packages";
  static const String PACKAGES_DURATION_KEY = "duration";
  static const String PACKAGES_PRICE_KEY = "price";

  GymDatabaseHelper._privateConstructor();

  static GymDatabaseHelper _instance = GymDatabaseHelper._privateConstructor();

  factory GymDatabaseHelper() {
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
    await firestore.collection(GYMS_COLLECTION_NAME).doc(uid).set({
      NAME_KEY: null,
      OPENING_TIME_KEY: null,
      LOCATION_KEY: [],
      PACKAGES_KEY: {},
    });
  }

  Future<void> deleteCurrentGymData() async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(GYMS_COLLECTION_NAME).doc(uid);

    await docRef.delete();
  }

  Stream<DocumentSnapshot> get currentGymDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore.collection(GYMS_COLLECTION_NAME).doc(uid).get().asStream();
  }

  Future<List<String>> get gymsList async {
    final productsCollectionReference = firestore.collection(GYMS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference.get();
    List<String> gyms = [];
    querySnapshot.docs.forEach((doc) {
      gyms.add(doc.id);
    });
    return gyms;
  }

  Future<Gym> getGymWithID(String gymID) async {
    final docSnapshot = await firestore.collection(GYMS_COLLECTION_NAME).doc(gymID).get();
    if (docSnapshot.exists) {
      var gym = Gym.fromMap(docSnapshot.data(), id: docSnapshot.id);
      // print(gym);
      return gym;
    }
    return null;
  }
}
