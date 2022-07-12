import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/components/product_card.dart';
import 'package:healthfix/screens/home/components/section_tile.dart';
import 'package:healthfix/services/data_streams/data_stream.dart';
import 'package:logger/logger.dart';

import '../../../size_config.dart';

// Cleaned
class ProductsSection extends StatefulWidget {
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
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  Stream _productStream;
  @override
  void initState() {
    _productStream = widget.productsStreamController.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        // horizontal: getProportionateScreenHeight(10),

        vertical: getProportionateScreenHeight(16),
      ),
      // height: getProportionateScreenHeight(280),

      // Title Bar
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(10),
            ),
            child: SectionTile(
              title: widget.sectionTitle,
              onPress: widget.onSeeMorePress,
            ),
          ),
          sizedBoxOfHeight(12),
          Container(height: getProportionateScreenHeight(200), child: buildProductsList()),
        ],
      ),
    );
  }

  Widget buildProductsList() {
    return StreamBuilder<List<String>>(
      stream: _productStream,
      builder: (context, snapshot) {
        print(snapshot.data);
        print((snapshot.data).runtimeType);
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(secondaryMessage: widget.emptyListMessage),
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
        mainAxisExtent: 150,
        // mainAxisSpacing: getProportionateScreenWidth(12),
      ),
      itemCount: productsId.length,
      itemBuilder: (context, index) {
        return ProductCard(
          productId: productsId[index],
          press: () {
            widget.onProductCardTapped.call(productsId[index]);
            print(productsId[index]);
          },
        );
      },
    );
  }
}
