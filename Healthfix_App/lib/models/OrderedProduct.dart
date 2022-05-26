import 'Model.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "product_uid";
  static const String ITEM_COUNT_KEY = "item_count";
  static const String PRODUCTS_KEY = "products";
  static const String ORDER_DATE_KEY = "order_date";
  static const String ORDER_DETAILS_KEY = "order_details";
  static const String ORDER_STATUS_KEY = "order_status";

  String productUid;
  List products;
  String orderDate;
  Map orderDetails;
  Map orderStatus;

  OrderedProduct(
    String id, {
    this.productUid,
    this.products,
    this.orderDate,
    this.orderDetails,
    this.orderStatus,
  }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String id}) {
    return OrderedProduct(
      id,
      // productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      products: map[PRODUCTS_KEY],
      orderDetails: map[ORDER_DETAILS_KEY],
      orderStatus: map[ORDER_STATUS_KEY],
    );
  }

  // @override
  // Map<String, dynamic> toMap() {
  //   final map = <String, dynamic>{
  //     PRODUCT_UID_KEY: productUid,
  //     ORDER_DATE_KEY: orderDate,
  //   };
  //   return map;
  // }
  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      PRODUCTS_KEY: products,
      ORDER_DATE_KEY: orderDate,
      ORDER_DETAILS_KEY: orderDetails,
      ORDER_STATUS_KEY: orderStatus,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    return map;
  }
}
