import 'package:healthfix/models/Model.dart';

class Gym extends Model {
  static const String NAME_KEY = "name";
  static const String DESC_KEY = "desc";
  static const String OPENING_TIME_KEY = "opening_time";
  static const String LOCATION_KEY = "location";
  static const String LOCATION_NAME_KEY = "address";
  static const String LOCATION_LINK_KEY = "map_link";
  static const String PACKAGES_KEY = "packages";
  static const String PACKAGES_DURATION_KEY = "duration";
  static const String PACKAGES_PRICE_KEY = "price";
  static const String IMAGE_URL_KEY = "imageURL";

  String name;
  String openingTime;
  String imageURL;
  String desc;
  Map location;
  List packages;

  Gym({
    String id,
    this.name,
    this.desc,
    this.openingTime,
    this.location,
    this.packages,
    this.imageURL,
  }) : super(id);

  factory Gym.fromMap(Map<String, dynamic> map, {String id}) {
    return Gym(
      id: id,
      name: map[NAME_KEY],
      desc: map[DESC_KEY],
      openingTime: map[OPENING_TIME_KEY],
      location: map[LOCATION_KEY],
      packages: map[PACKAGES_KEY],
      imageURL: map[IMAGE_URL_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map map;
    map = <String, dynamic>{
      NAME_KEY: name,
      DESC_KEY: desc,
      OPENING_TIME_KEY: openingTime,
      LOCATION_KEY: location,
      PACKAGES_KEY: packages,
      IMAGE_URL_KEY: imageURL,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (name != null) map[NAME_KEY] = name;
    return map;
  }
}
