import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthfix/models/Address.dart';
import 'package:healthfix/models/CartItem.dart';
import 'package:healthfix/models/GymSubscription.dart';
import 'package:healthfix/models/OrderedProduct.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/product_database_helper.dart';

class UserDatabaseHelper {
  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";
  static const String GYM_SUBSCRIPTIONS_COLLECTION_NAME = "gym_subscriptions";

  static const String PHONE_KEY = 'phone';
  static const String DP_KEY = "display_picture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";

  UserDatabaseHelper._privateConstructor();

  static UserDatabaseHelper _instance = UserDatabaseHelper._privateConstructor();

  factory UserDatabaseHelper() {
    return _instance;
  }

  FirebaseFirestore _firebaseFirestore;

  FirebaseFirestore get firestore {
    if (_firebaseFirestore == null) {
      _firebaseFirestore = FirebaseFirestore.instance;
    }
    return _firebaseFirestore;
  }

  Future<void> createNewUser(String uid) async {
    await firestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: null,
      FAV_PRODUCTS_KEY: List<String>(),
    });
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
    final ordersCollectionRef = docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

    final cartDocs = await cartCollectionRef.get();
    for (final cartDoc in cartDocs.docs) {
      await cartCollectionRef.doc(cartDoc.id).delete();
    }
    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }
    final ordersDoc = await ordersCollectionRef.get();
    for (final orderDoc in ordersDoc.docs) {
      await ordersCollectionRef.doc(orderDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData[FAV_PRODUCTS_KEY].cast<String>();
    if (favList.contains(productId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List> get usersFavouriteProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData[FAV_PRODUCTS_KEY];
    return favList;
  }

  Future<bool> switchProductFavouriteStatus(String productId, bool newState) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);

    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
    return true;
  }

  Future<List<String>> get addressesList async {
    String uid = AuthentificationService().currentUser.uid;
    final snapshot = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).get();
    final addresses = List<String>();
    snapshot.docs.forEach((doc) {
      addresses.add(doc.id);
    });

    return addresses;
  }

  Future<Address> getAddressFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).doc(id).get();
    final address = Address.fromMap(doc.data(), id: doc.id);
    return address;
  }

  Future<bool> getNameForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressesCollectionReference = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> addAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressesCollectionReference = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> addGymSubscriptionForCurrentUser(GymSubscription gymSubscription) async {
    String uid = AuthentificationService().currentUser.uid;
    final gymSubscriptionsCollectionReference = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(GYM_SUBSCRIPTIONS_COLLECTION_NAME);
    await gymSubscriptionsCollectionReference.add(gymSubscription.toMap());
    return true;
  }

  Future<bool> deleteAddressForCurrentUser(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressDocReference = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).doc(id);
    await addressDocReference.delete();
    return true;
  }

  Future<bool> updateAddressForCurrentUser(Address address) async {
    String uid = AuthentificationService().currentUser.uid;
    final addressDocReference = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).doc(address.id);
    await addressDocReference.update(address.toMap());
    return true;
  }

  Future<CartItem> getCartItemFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    final cartItem = CartItem.fromMap(docSnapshot.data(), id: docSnapshot.id);
    return cartItem;
  }

  Future getUserDataFromId(String id) async {
    // String uid = AuthentificationService().currentUser.uid;
    final docRef = firestore.collection(USERS_COLLECTION_NAME).doc(id);
    // final docRef = cartCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    return docSnapshot.data();
  }

  Future<GymSubscription> getGymSubscriptionFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final gymSubscriptionsCollectionRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(GYM_SUBSCRIPTIONS_COLLECTION_NAME);
    final docRef = gymSubscriptionsCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    final gymSubscription = GymSubscription.fromMap(docSnapshot.data(), id: docSnapshot.id);
    return gymSubscription;
  }

  Future<bool> addProductToCart(String productId, Map variation) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(productId);
    final docSnapshot = await docRef.get();
    bool alreadyPresent = docSnapshot.exists;
    // If New Product
    if (alreadyPresent == false) {
      print("already");
      docRef.set(CartItem(itemCount: 1, variation: variation).toMap());
      // If Already Product
    } else {
      List _variation = docSnapshot.data()["variation"];
      print(_variation);
      // If with Single Variant
      if (_variation == null) {
        docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
      }
      // If has Variantion
      else {
        docRef.set(CartItem(itemCount: 1, variation: _variation).toMap());

        // _variation.remove(CartItem.ITEM_COUNT_KEY);
        _variation.forEach((vari) {
          if (vari["size"] == variation["size"] && vari["color"]["name"] == variation["color"]["name"]) {
            vari[CartItem.ITEM_COUNT_KEY]++;
            docRef.update({CartItem.VARIATION_KEY: _variation});
          } else {
            _variation.add(variation);
            docRef.set(CartItem(itemCount: 1, variation: _variation).toMap());
          }
        });

        // _variation[CartItem.ITEM_COUNT_KEY]++;
        // print(_variation);
        // docRef.update({CartItem.VARIATION_KEY: _variation});
        // print(CartItem.VARIATION_KEY);
      }
    }
    return true;
  }

  Future<Map> emptyCart() async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    Map orderedProductsUid = {};
    for (final doc in cartItems.docs) {
      orderedProductsUid[doc.id] = doc.data();
      // orderedProductsUid.add(doc.id);
      await doc.reference.delete();
    }
    // print(orderedProductsUid);
    return orderedProductsUid;
  }

  Future<Map> emptySelectedCart(List selectedProductsUid) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    Map orderedProductsUid = {};
    for (final doc in cartItems.docs) {
      if(selectedProductsUid.contains(doc.id)){
        print("contains ${doc.id}");
        orderedProductsUid[doc.id] = doc.data();
        // orderedProductsUid.add(doc.id);
        await doc.reference.delete();
      }
    }
    // print(orderedProductsUid);
    return orderedProductsUid;
  }

  Future<num> get cartTotal async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    num total = 0.0;
    for (final doc in cartItems.docs) {
      num itemsCount;
      print("item");
      // print(doc.data()[CartItem.VARIATION_KEY]);
      if (doc.data()[CartItem.VARIATION_KEY] == null) {
        itemsCount = doc.data()[CartItem.ITEM_COUNT_KEY];
      } else {
        itemsCount = doc.data()[CartItem.VARIATION_KEY][0][CartItem.ITEM_COUNT_KEY];
      }
      final product = await ProductDatabaseHelper().getProductWithID(doc.id);
      total += (itemsCount * product.discountPrice);
    }
    return total;
  }

  Future<num> selectedCartTotal(List selectedCartItemIDs) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartItems = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    num total = 0.0;
    for (final doc in cartItems.docs) {
      num itemsCount;
      print(doc.id);
      if(selectedCartItemIDs.contains(doc.id)){
        if (doc.data()[CartItem.VARIATION_KEY] == null) {
          itemsCount = doc.data()[CartItem.ITEM_COUNT_KEY];
        } else {
          itemsCount = doc.data()[CartItem.VARIATION_KEY][0][CartItem.ITEM_COUNT_KEY];
        }
        final product = await ProductDatabaseHelper().getProductWithID(doc.id);
        total += (itemsCount * product.discountPrice);
      }
    }
    return total;
  }

  Future<bool> removeProductFromCart(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionReference = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    await cartCollectionReference.doc(cartItemID).delete();
    return true;
  }

  Future<bool> increaseCartItemCount(String cartItemID, Map variation) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    // final docSnapshot = await docRef.get();
    // List _variation = docSnapshot.data()["variation"];
    // print(_variation);
    // // If with Single Variant
    // if (_variation == null) {
    //   docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    // }
    // // If has Variantion
    // else {
    //   // _variation.remove(CartItem.ITEM_COUNT_KEY);
    //   _variation.forEach((vari) {
    //     if (vari["size"] == variation["size"] && vari["color"]["name"] == variation["color"]["name"]) {
    //       vari[CartItem.ITEM_COUNT_KEY]++;
    //       docRef.update({CartItem.VARIATION_KEY: _variation});
    //     } else {
    //       _variation.add(variation);
    //       docRef.set(CartItem(itemCount: 1, variation: _variation).toMap());
    //     }
    //   });
    //
    //   // _variation[CartItem.ITEM_COUNT_KEY]++;
    //   // print(_variation);
    //   // docRef.update({CartItem.VARIATION_KEY: _variation});
    //   // print(CartItem.VARIATION_KEY);
    // }
    return true;
  }

  Future<bool> decreaseCartItemCount(String cartItemID) async {
    String uid = AuthentificationService().currentUser.uid;
    final cartCollectionRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    final docSnapshot = await docRef.get();
    int currentCount = docSnapshot.data()[CartItem.ITEM_COUNT_KEY];
    if (currentCount <= 1) {
      return removeProductFromCart(cartItemID);
    } else {
      docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(-1)});
    }
    return true;
  }

  Future<List<String>> get allCartItemsList async {
    String uid = AuthentificationService().currentUser.uid;
    final querySnapshot = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    List itemsId = List<String>();
    for (final item in querySnapshot.docs) {
      itemsId.add(item.id);
      // print(item.data());
    }
    return itemsId;
  }

  Future<List<String>> get orderedProductsList async {
    String uid = AuthentificationService().currentUser.uid;
    final orderedProductsSnapshot = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ORDERED_PRODUCTS_COLLECTION_NAME).get();
    List orderedProductsId = List<String>();
    for (final doc in orderedProductsSnapshot.docs) {
      orderedProductsId.add(doc.id);
    }
    return orderedProductsId;
  }

  Future<List<String>> get gymSubscriptionsList async {
    String uid = AuthentificationService().currentUser.uid;
    final gymSubscriptionsSnapshot = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(GYM_SUBSCRIPTIONS_COLLECTION_NAME).get();
    List gymSubscriptionsId = List<String>();
    for (final doc in gymSubscriptionsSnapshot.docs) {
      gymSubscriptionsId.add(doc.id);
    }
    return gymSubscriptionsId;
  }

  Future<bool> addToMyOrders(OrderedProduct order) async {
    String uid = AuthentificationService().currentUser.uid;
    final orderedProductsCollectionRef = firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ORDERED_PRODUCTS_COLLECTION_NAME);
      await orderedProductsCollectionRef.add(order.toMap());
    // for (final order in orders) {
    //   await orderedProductsCollectionRef.add(order.toMap());
    // }
    return true;
  }

  Future<OrderedProduct> getOrderedProductFromId(String id) async {
    String uid = AuthentificationService().currentUser.uid;
    final doc = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ORDERED_PRODUCTS_COLLECTION_NAME).doc(id).get();
    final orderedProduct = OrderedProduct.fromMap(doc.data(), id: doc.id);
    return orderedProduct;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthentificationService().currentUser.uid;
    return firestore.collection(USERS_COLLECTION_NAME).doc(uid).get().asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthentificationService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {DP_KEY: url},
    );
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = firestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update(
      {
        DP_KEY: FieldValue.delete(),
      },
    );
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthentificationService().currentUser.uid;
    final userDocSnapshot = await firestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()[DP_KEY];
  }
}
