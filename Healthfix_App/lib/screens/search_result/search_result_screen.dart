import 'package:flutter/material.dart';
import 'package:healthfix/components/search_field.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/services/data_streams/all_products_stream.dart';
import 'package:healthfix/services/database/product_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import 'components/body.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;
  final String searchIn;
  final List<String> searchResultProductsId;

  SearchResultScreen({
    Key key,
    @required this.searchQuery,
    @required this.searchResultProductsId,
    @required this.searchIn,
  }) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final AllProductsStream allProductsStream = AllProductsStream();

  @override
  void initState() {
    super.initState();
    allProductsStream.init();
  }

  @override
  void dispose() {
    allProductsStream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Function onSearchSubmitted = (value) async {
      final query = value.toString();
      if (query.length <= 0) return;
      List<String> searchedProductsId;
      try {
        searchedProductsId = await ProductDatabaseHelper().searchInProducts(query.toLowerCase());
        if (searchedProductsId != null) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultScreen(
                searchQuery: query,
                searchResultProductsId: searchedProductsId,
                searchIn: "All Products",
              ),
            ),
          );
          await refreshPage();
        } else {
          throw "Couldn't perform search due to some unknown reason";
        }
      } catch (e) {
        final error = e.toString();
        Logger().e(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$error"),
          ),
        );
      }
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Search Products",
          style: cusHeadingStyle(),
        ),
        leadingWidth: 20,
        actions: [],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: SizeConfig.screenWidth * 0.9,
                child: SearchField(
                  onSubmit: onSearchSubmitted,
                  searchQuery: widget.searchQuery,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.filter_list_rounded),
              ),
            ],
          ),
          Body(
            searchQuery: widget.searchQuery,
            searchResultProductsId: widget.searchResultProductsId,
            searchIn: widget.searchIn,
          ),
        ],
      ),
    );
  }

  Future<void> refreshPage() {
    allProductsStream.reload();
    return Future<void>.value();
  }
}
