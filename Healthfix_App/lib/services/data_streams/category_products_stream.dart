import 'package:healthfix/models/Product.dart';
import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';

class CategoryProductsStream extends DataStream<List<String>> {
  final ProductType category;
  final String subCategory;
  final String searchString;

  CategoryProductsStream(this.category, [this.subCategory, this.searchString]);

  @override
  void reload() {
    Future allProductsFuture;

    if (searchString != null) {
      if (searchString.isNotEmpty) {
        allProductsFuture = ProductDatabaseHelper().searchInProducts(searchString, category, subCategory);
      }
    } else {
      allProductsFuture = ProductDatabaseHelper().getCategoryProductsList(category, subCategory);
    }

    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
