import 'package:flutter/material.dart';
import 'package:healthfix/screens/seller/components/body.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Body(),
    );
  }
}
