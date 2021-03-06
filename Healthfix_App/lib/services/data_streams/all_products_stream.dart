import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';

class SomeProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = ProductDatabaseHelper().someProductsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
