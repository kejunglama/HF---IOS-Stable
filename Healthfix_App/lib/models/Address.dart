import 'Model.dart';

class Address extends Model {
  static const String TITLE_KEY = "title";
  static const String ADDRESS_KEY = "address";
  // static const String ADDRESS_LINE_2_KEY = "address_line_2";
  static const String CITY_KEY = "city";
  static const String ZONE_KEY = "zone";
  // static const String STATE_KEY = "state";
  static const String LANDMARK_KEY = "landmark";
  // static const String PINCODE_KEY = "pincode";
  static const String RECEIVER_KEY = "receiver";
  static const String PHONE_KEY = "phone";

  String title;
  String receiver;
  String address;
  String city;
  String zone;
  // String state;
  String landmark;
  String phone;

  Address({
    String id,
    this.title,
    this.receiver,
    this.address,
    this.city,
    this.zone,
    // this.state,
    this.landmark,
    this.phone,
  }) : super(id);

  factory Address.fromMap(Map<String, dynamic> map, {String id}) {
    return Address(
      id: id,
      title: map[TITLE_KEY],
      receiver: map[RECEIVER_KEY],
      address: map[ADDRESS_KEY],
      city: map[CITY_KEY],
      zone: map[ZONE_KEY],
      // state: map[STATE_KEY],
      landmark: map[LANDMARK_KEY],
      phone: map[PHONE_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      TITLE_KEY: title,
      RECEIVER_KEY: receiver,
      ADDRESS_KEY: address,
      CITY_KEY: city,
      ZONE_KEY: zone,
      // STATE_KEY: state,
      LANDMARK_KEY: landmark,
      PHONE_KEY: phone,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (title != null) map[TITLE_KEY] = title;
    if (receiver != null) map[RECEIVER_KEY] = receiver;
    if (address != null) map[ADDRESS_KEY] = address;
    if (city != null) map[CITY_KEY] = city;
    // if (district != null) map[DISTRICT_KEY] = district;
    // if (state != null) map[STATE_KEY] = state;
    if (landmark != null) map[LANDMARK_KEY] = landmark;
    if (phone != null) map[PHONE_KEY] = phone;
    return map;
  }
}
