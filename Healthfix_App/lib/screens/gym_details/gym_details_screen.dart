import 'package:flutter/material.dart';
import 'package:healthfix/components/app_back_button.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Gym.dart';

import 'components/body.dart';

class GymDetailsScreen extends StatelessWidget {
  Gym gym;

  GymDetailsScreen(this.gym);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.orange, //change your color here
        ),
        leading: AppBackBtn(),
      ),
      body: Body(gym),
    );
  }
}
