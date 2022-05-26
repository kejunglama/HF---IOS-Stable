import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/gym_database_helper.dart';

class GymsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final gymsFuture = GymDatabaseHelper().gymsList;
    gymsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
