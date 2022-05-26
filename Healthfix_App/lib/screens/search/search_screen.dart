import 'package:flutter/material.dart';
import 'package:healthfix/components/search_field.dart';
import 'package:healthfix/screens/home/components/products_section.dart';
import 'package:healthfix/services/data_streams/all_products_stream.dart';

import '../../size_config.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen();
  final AllProductsStream allProductsStream = AllProductsStream();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Product"),
        actions: [
          Icon(Icons.filter_list_rounded),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: SearchField(
                // onSubmit: onSearchSubmitted,
            ),
          ),
          Container(
            height: SizeConfig.screenHeight * 0.36,
            child: ProductsSection(
              sectionTitle: "Explore All Products",
              productsStreamController: allProductsStream,
              emptyListMessage: "Looks like all Stores are closed",
              // onProductCardTapped: onProductCardTapped,
            ),
          ),
        ],
      ),
    );
  }
}
