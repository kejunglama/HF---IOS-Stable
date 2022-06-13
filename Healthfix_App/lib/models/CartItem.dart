import 'package:healthfix/models/Model.dart';

class CartItem extends Model {
  static const String PRODUCT_ID_KEY = "product_id";
  static const String ITEM_COUNT_KEY = "item_count";
  static const String VARIATION_KEY = "variation";
  static const String VARIATION_ID_KEY = "var_id";
  static const String VARIATION_COUNT_KEY = "item_count";

  String productId;
  int itemCount;
  // String variantId;

  CartItem({
    String id,
    this.productId,
    this.itemCount = 0,
    // this.variantId,
  }) : super(id);

  factory CartItem.fromMap(Map<String, dynamic> map, {String id}) {
    return CartItem(
      id: id,
      productId: map[PRODUCT_ID_KEY],
      itemCount: map[ITEM_COUNT_KEY],
      // variantId: map[VARIATION_ID_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // print("variation in DBHELPER");
    Map map;
    map = <String, dynamic>{
      PRODUCT_ID_KEY: productId,
      ITEM_COUNT_KEY: itemCount,
      // VARIATION_ID_KEY: variantId,
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
    if (productId != null) map[PRODUCT_ID_KEY] = productId;
    if (itemCount != null) map[ITEM_COUNT_KEY] = itemCount;
    // if (variantId != null) map[VARIATION_ID_KEY] = variantId;
    return map;
  }
}
