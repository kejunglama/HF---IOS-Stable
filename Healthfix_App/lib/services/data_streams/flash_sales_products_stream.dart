import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';

class FlashSalesProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final flashSalesProductsFuture = ProductDatabaseHelper().featuredProductsList;
    flashSalesProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
