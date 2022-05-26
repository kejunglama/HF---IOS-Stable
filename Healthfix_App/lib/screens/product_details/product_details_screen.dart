import 'package:flutter/material.dart';
import 'package:healthfix/components/rounded_icon_button.dart';
import 'package:healthfix/models/Product.dart';
import 'package:healthfix/screens/product_details/provider_models/ProductActions.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';
import 'components/body.dart';

class ProductDetailsScreen extends StatelessWidget {

  final String productId;
  Product product;

  ProductDetailsScreen({
    Key key,
    @required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FutureBuilder<Product>(
    //   future: ProductDatabaseHelper().getProductWithID(productId),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       product = snapshot.data;
    //     } else if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(child: CircularProgressIndicator());
    //     } else if (snapshot.hasError) {
    //       final error = snapshot.error.toString();
    //       Logger().e(error);
    //     }
    //     return Center(
    //       child: Icon(
    //         Icons.error,
    //         color: kTextColor,
    //         size: 60,
    //       ),
    //     );
    //   },
    // );

    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Body(
          productId: productId,
        ),
        // floatingActionButton: AddToCartFAB(productId: productId),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        // bottomNavigationBar: BottomAppBar(
        //   child: Container(
        //     color: kPrimaryColor,
        //     height: getProportionateScreenHeight(50),
        //     child: Row(
        //       children: [
        //         VerticalDivider(
        //           thickness: 1,
        //           color: Colors.white,
        //         ),
        //         Expanded(
        //           child: TextButton.icon(
        //             onPressed: () {},
        //             icon: Icon(
        //               Icons.shopping_bag_outlined,
        //               color: Colors.white,
        //             ),
        //             label: Text(
        //               "Buy Now",
        //               style: cusHeadingStyle(
        //                 getProportionateScreenHeight(14),
        //                 Colors.white,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
