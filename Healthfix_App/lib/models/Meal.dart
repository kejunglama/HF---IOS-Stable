import 'package:healthfix/models/Model.dart';

class Meal extends Model {
  static const String TITLE_KEY = "title";
  static const String DESCRIPTION_KEY = "description";
  static const String INGREDIENTS_KEY = "ingredients";
  static const String VALUES_KEY = "values";
  static const String IMAGES_KEY = "images";
  static const String DISCOUNT_PRICE_KEY = "discount_price";
  static const String ORIGINAL_PRICE_KEY = "original_price";
  static const String SELLER_KEY = "seller";
  static const String BRAND_KEY = "brand";

  String title;
  String desc;
  String ingredients;
  Map values;
  List images;
  num discountPrice;
  num originalPrice;
  String seller;
  String brand;

  Meal({
    String id,
    this.title,
    this.desc,
    this.ingredients,
    this.values,
    this.images,
    this.discountPrice,
    this.originalPrice,
    this.seller,
    this.brand,
  }) : super(id);

  factory Meal.fromMap(Map<String, dynamic> map, {String id}) {
    return Meal(
      id: id,
      title: map[TITLE_KEY],
      desc: map[DESCRIPTION_KEY],
      ingredients: map[INGREDIENTS_KEY],
      values: map[VALUES_KEY],
      images: map[IMAGES_KEY],
      discountPrice: map[DISCOUNT_PRICE_KEY],
      originalPrice: map[ORIGINAL_PRICE_KEY],
      seller: map[SELLER_KEY],
      brand: map[BRAND_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map map;
    map = <String, dynamic>{
      TITLE_KEY: title,
      DESCRIPTION_KEY: desc,
      INGREDIENTS_KEY: ingredients,
      VALUES_KEY: values,
      IMAGES_KEY: images,
      DISCOUNT_PRICE_KEY: discountPrice,
      ORIGINAL_PRICE_KEY: originalPrice,
      SELLER_KEY: seller,
      BRAND_KEY: brand,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (title != null) map[TITLE_KEY] = title;
    if (desc != null) map[DESCRIPTION_KEY] = desc;
    if (ingredients != null) map[INGREDIENTS_KEY] = ingredients;
    if (values != null) map[VALUES_KEY] = values;
    if (images != null) map[IMAGES_KEY] = images;
    if (discountPrice != null) map[DISCOUNT_PRICE_KEY] = discountPrice;
    if (originalPrice != null) map[ORIGINAL_PRICE_KEY] = originalPrice;
    if (seller != null) map[SELLER_KEY] = seller;
    if (brand != null) map[BRAND_KEY] = brand;
    return map;
  }
}
