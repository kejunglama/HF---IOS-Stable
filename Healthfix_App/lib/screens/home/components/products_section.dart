import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_card.dart';
import 'package:healthfix/screens/home/components/section_tile.dart';
import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:logger/logger.dart';

import '../../../size_config.dart';

// Cleaned
class ProductsSection extends StatelessWidget {
  final String sectionTitle;
  final DataStream productsStreamController;
  final String emptyListMessage;
  final Function onProductCardTapped;
  final Function onSeeMorePress;

  const ProductsSection({
    Key key,
    @required this.sectionTitle,
    @required this.productsStreamController,
    this.emptyListMessage = "No Products to show here",
    this.onProductCardTapped,
    this.onSeeMorePress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        // horizontal: getProportionateScreenHeight(10),
        vertical: getProportionateScreenHeight(16),
      ),

      // Title Bar
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(10),
            ),
            child: SectionTile(
              title: sectionTitle,
              onPress: onSeeMorePress,
            ),
          ),
          sizedBoxOfHeight(12),
          Expanded(child: buildProductsList()),
        ],
      ),
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<String>>(
      stream: productsStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(secondaryMessage: emptyListMessage),
            );
          }
          return buildProductGrid(snapshot.data);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          final error = snapshot.error;
          Logger().w(error.toString());
        }
        return Center(
          child: NothingToShowContainer(
            iconPath: "assets/icons/network_error.svg",
            primaryMessage: "Something went wrong",
            secondaryMessage: "Unable to connect to Database",
          ),
        );
      },
    );
  }

  Widget buildProductGrid(List<String> productsId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        // childAspectRatio: 1,
        mainAxisExtent: getProportionateScreenWidth(132),
        // mainAxisSpacing: getProportionateScreenWidth(12),
      ),
      itemCount: productsId.length,
      itemBuilder: (context, index) {
        return ProductCard(
          productId: productsId[index],
          press: () {
            onProductCardTapped.call(productsId[index]);
          },
        );
      },
    );
  }
}
