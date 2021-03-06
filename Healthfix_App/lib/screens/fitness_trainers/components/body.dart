import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthfix/services/data_streams/trainers_stream.dart';

import 'fitness_trainers_sections.dart';

class Body extends StatefulWidget {
  Body();

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TrainersStream trainersStream = TrainersStream();

  @override
  void initState() {
    super.initState();
    trainersStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    trainersStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FitnessTrainersSection(trainersStream);
  }
}
