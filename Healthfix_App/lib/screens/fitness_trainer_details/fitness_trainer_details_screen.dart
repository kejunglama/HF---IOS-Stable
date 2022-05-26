import 'package:flutter/material.dart';
import 'package:healthfix/app.dart';
import 'package:healthfix/models/Trainer.dart';

import 'components/body.dart';

class FitnessTrainerDetailsScreen extends StatelessWidget {
  Trainer trainer;
  FitnessTrainerDetailsScreen(this.trainer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Body(trainer),
    );
  }
}
