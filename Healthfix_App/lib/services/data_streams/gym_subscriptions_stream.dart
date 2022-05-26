import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/user_database_helper.dart';

class GymSubscriptionsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final gymSubscriptionsFuture = UserDatabaseHelper().gymSubscriptionsList;
    gymSubscriptionsFuture.then((data) {
      addData(data);
    }).catchError((e) {
      addError(e);
    });
  }
}
