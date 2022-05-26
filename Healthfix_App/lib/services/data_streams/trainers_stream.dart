import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/trainers_database_helper.dart';

class TrainersStream extends DataStream<List<String>> {
  @override
  void reload() {
    final trainersFuture = TrainersDatabaseHelper().trainersList;
    trainersFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
