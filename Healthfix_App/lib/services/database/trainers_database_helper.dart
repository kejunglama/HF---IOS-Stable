import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthfix/models/Trainer.dart';

class TrainersDatabaseHelper {
  static const String GYMS_COLLECTION_NAME = "gym";
  static const String TRAINERS_COLLECTION_NAME = "trainers";

  TrainersDatabaseHelper._privateConstructor();

  static TrainersDatabaseHelper _instance = TrainersDatabaseHelper._privateConstructor();

  factory TrainersDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;

  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<List<String>> get trainersList async {
    final productsCollectionReference = firestore.collection(TRAINERS_COLLECTION_NAME);
    final querySnapshot = await productsCollectionReference.get();
    List<String> trainers = [];
    querySnapshot.docs.forEach((doc) {
      trainers.add(doc.id);
    });
    return trainers;
  }

  Future<Trainer> getTrainerWithID(String trainerID) async {
    final docSnapshot = await firestore.collection(TRAINERS_COLLECTION_NAME).doc(trainerID).get();
    if (docSnapshot.exists) {
      var trainer = Trainer.fromMap(docSnapshot.data(), id: docSnapshot.id);
      return trainer;
    }
    return null;
  }
}
