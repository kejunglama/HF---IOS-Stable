import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';

class SomeProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final someProductsFuture = ProductDatabaseHelper().someProductsList;
    someProductsFuture.then((products) {
      addData(products);
    }).catchError((e) {
      addError(e);
    });
  }
}
