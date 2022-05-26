import 'package:healthfix/models/Model.dart';

class Trainer extends Model {
  static const String NAME_KEY = "name";
  static const String IMAGE_URL_KEY = "imageURL";
  static const String TITLE_KEY = "title";
  static const String EXPERIENCE_KEY = "experience";
  static const String DESCRIPTION_KEY = "description";
  static const String SPECIALIZATION_KEY = "specialization";
  static const String TIMINGS_KEY = "timings";

  String name;
  String imageURL;
  String title;
  String experience;
  String description;
  String specialization;
  List timings;

  Trainer({
    String id,
    this.name,
    this.imageURL,
    this.title,
    this.experience,
    this.description,
    this.specialization,
    this.timings,
  }) : super(id);

  factory Trainer.fromMap(Map<String, dynamic> map, {String id}) {
    return Trainer(
      id: id,
      name: map[NAME_KEY],
      imageURL: map[IMAGE_URL_KEY],
      title: map[TITLE_KEY],
      experience: map[EXPERIENCE_KEY],
      description: map[DESCRIPTION_KEY],
      specialization: map[SPECIALIZATION_KEY],
      timings: map[TIMINGS_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    Map map;
    map = <String, dynamic>{
      NAME_KEY: name,
      IMAGE_URL_KEY: imageURL,
      TITLE_KEY: title,
      EXPERIENCE_KEY: experience,
      DESCRIPTION_KEY: description,
      SPECIALIZATION_KEY: specialization,
      TIMINGS_KEY: timings,
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
