import 'package:flutter/material.dart';
import 'components/body.dart';

class ManageAddressesScreen extends StatelessWidget {
  bool isSelectAddressScreen;
  ManageAddressesScreen({this.isSelectAddressScreen});

  @override
  Widget build(BuildContext context) {
    bool _isSelectAddressScreen = isSelectAddressScreen ?? false;

    return Scaffold(
      appBar: AppBar(),
      body: Body(_isSelectAddressScreen),
    );
  }
}
