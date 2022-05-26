// import 'dart:ffi';

import 'package:healthfix/models/Model.dart';

class CartItem extends Model {
  static const String PRODUCT_ID_KEY = "product_id";
  static const String ITEM_COUNT_KEY = "item_count";
  static const String VARIATION_KEY = "variation";

  int itemCount;
  dynamic variation;

  CartItem({
    String id,
    this.itemCount = 0,
    this.variation,
  }) : super(id);

  factory CartItem.fromMap(Map<String, dynamic> map, {String id}) {
    return CartItem(
      id: id,
      itemCount: map[ITEM_COUNT_KEY],
      variation: map[VARIATION_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // print("variation in DBHELPER");
    Map map;
    map = <String, dynamic>{
      ITEM_COUNT_KEY: itemCount,
    };
    // if(variation != null){
    //   if (variation.isEmpty) {
    //     map = <String, dynamic>{
    //       ITEM_COUNT_KEY: itemCount,
    //     };
    //   } else {
    //     variation[ITEM_COUNT_KEY] = itemCount;
    //     // print(variation);
    //     map = <String, dynamic>{
    //       VARIATION_KEY: [variation],
    //     };
    //   }
    // }
    // print("$map $variation");
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (itemCount != null) map[ITEM_COUNT_KEY] = itemCount;
    return map;
  }
}
