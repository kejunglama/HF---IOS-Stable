import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';

class FeaturedProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final featuredProductsFuture = ProductDatabaseHelper().featuredProductsList;
    featuredProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
