import 'package:enum_to_string/enum_to_string.dart';
import 'package:healthfix/models/Model.dart';

enum ProductType {
  All,
  Nutrition,
  Supplements,
  Food,
  Clothing,
  Explore,
}

class Product extends Model {
  static const String IMAGES_KEY = "images";
  static const String TITLE_KEY = "title";
  static const String BRAND_KEY = "brand";
  static const String DISCOUNT_PRICE_KEY = "discount_price";
  static const String ORIGINAL_PRICE_KEY = "original_price";
  static const String PRICE_RANGE_KEY = "price_range";
  static const String RATING_KEY = "rating";
  static const String HIGHLIGHTS_KEY = "highlights";
  static const String DESCRIPTION_KEY = "description";
  static const String SELLER_KEY = "seller";
  static const String OWNER_KEY = "owner";
  static const String PRODUCT_TYPE_KEY = "product_type";
  static const String PRODUCT_SUBTYPE_KEY = "product_sub_type";
  static const String SEARCH_TAGS_KEY = "search_tags";
  static const String IS_FEATURED_KEY = "is_featured";
  static const String VARIATIONS_KEY = "variations";

  List<String> images;
  String title;
  String brand;
  num discountPrice;
  num originalPrice;
  num priceRange;
  num rating;
  String highlights;
  String description;
  String seller;
  bool favourite;
  String owner;
  ProductType productType;
  List<String> searchTags;
  List variations;

  Product(
    String id, {
    this.images,
    this.title,
    this.brand,
    this.productType,
    this.discountPrice,
    this.originalPrice,
    this.priceRange,
    this.rating = 0.0,
    this.highlights,
    this.description,
    this.seller,
    this.owner,
    this.searchTags,
    this.variations,
  }) : super(id);

  int calculatePercentageDiscount() {
    int discount =
        (((originalPrice - discountPrice) * 100) / originalPrice).round();
    return discount;
  }

  factory Product.fromMap(Map<String, dynamic> map, {String id}) {
    if (map[SEARCH_TAGS_KEY] == null) {
      map[SEARCH_TAGS_KEY] = [];
    }
    return Product(
      id,
      images: (map[IMAGES_KEY] ?? []).cast<String>(),
      title: map[TITLE_KEY],
      brand: map[BRAND_KEY],
      productType:
          EnumToString.fromString(ProductType.values, map[PRODUCT_TYPE_KEY]),
      discountPrice: map[DISCOUNT_PRICE_KEY],
      originalPrice: map[ORIGINAL_PRICE_KEY],
      priceRange: map[PRICE_RANGE_KEY],
      rating: map[RATING_KEY],
      highlights: map[HIGHLIGHTS_KEY],
      description: map[DESCRIPTION_KEY],
      seller: map[SELLER_KEY],
      owner: map[OWNER_KEY],
      searchTags: map[SEARCH_TAGS_KEY].cast<String>(),
      variations: map[VARIATIONS_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      IMAGES_KEY: images,
      TITLE_KEY: title,
      BRAND_KEY: brand,
      PRODUCT_TYPE_KEY: EnumToString.convertToString(productType),
      DISCOUNT_PRICE_KEY: discountPrice,
      ORIGINAL_PRICE_KEY: originalPrice,
      PRICE_RANGE_KEY: priceRange,
      RATING_KEY: rating,
      HIGHLIGHTS_KEY: highlights,
      DESCRIPTION_KEY: description,
      SELLER_KEY: seller,
      OWNER_KEY: owner,
      SEARCH_TAGS_KEY: searchTags,
      VARIATIONS_KEY: variations,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (images != null) map[IMAGES_KEY] = images;
    if (title != null) map[TITLE_KEY] = title;
    if (brand != null) map[BRAND_KEY] = brand;
    if (discountPrice != null) map[DISCOUNT_PRICE_KEY] = discountPrice;
    if (originalPrice != null) map[ORIGINAL_PRICE_KEY] = originalPrice;
    if (priceRange != null) map[PRICE_RANGE_KEY] = priceRange;
    if (rating != null) map[RATING_KEY] = rating;
    if (highlights != null) map[HIGHLIGHTS_KEY] = highlights;
    if (description != null) map[DESCRIPTION_KEY] = description;
    if (seller != null) map[SELLER_KEY] = seller;
    if (productType != null)
      map[PRODUCT_TYPE_KEY] = EnumToString.convertToString(productType);
    if (owner != null) map[OWNER_KEY] = owner;
    if (searchTags != null) map[SEARCH_TAGS_KEY] = searchTags;
    if (variations != null) map[VARIATIONS_KEY] = variations;

    return map;
  }
}
