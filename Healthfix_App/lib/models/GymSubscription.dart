import 'package:healthfix/models/Model.dart';

class GymSubscription extends Model {
  static const String GYM_ID_KEY = "gym_id";
  static const String GYM_NAME_KEY = "gym_name";
  static const String PACKAGE_KEY = "package";
  static const String PACKAGE_DURATION_KEY = "duration";
  static const String PACKAGE_PRICE_KEY = "price";
  static const String STARTING_FROM_KEY = "starting_from";
  static const String SUBSCRIBED_ON_KEY = "subscribed_on";

  String gymID;
  String gymName;
  Map package;
  String startingFrom;
  String subscribedOn;

  GymSubscription({
    String id,
    this.gymID,
    this.gymName,
    this.package,
    this.startingFrom,
    this.subscribedOn,
  }) : super(id);

  factory GymSubscription.fromMap(Map<String, dynamic> map, {String id}) {
    return GymSubscription(
      id: id,
      gymID: map[GYM_ID_KEY],
      gymName: map[GYM_NAME_KEY],
      package: map[PACKAGE_KEY],
      startingFrom: map[STARTING_FROM_KEY],
      subscribedOn: map[SUBSCRIBED_ON_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map map = <String, dynamic>{
      GYM_ID_KEY: gymID,
      GYM_NAME_KEY: gymName,
      PACKAGE_KEY: package,
      STARTING_FROM_KEY: startingFrom,
      SUBSCRIBED_ON_KEY: subscribedOn,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (gymName != null) map[GYM_NAME_KEY] = gymName;
    return map;
  }
}
