import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthfix/screens/gym_membership/components/gym_sections.dart';
import 'package:healthfix/services/data_streams/gyms_stream.dart';
import 'package:healthfix/services/database/gym_database_helper.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  Body();

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GymsStream gymsStream = GymsStream();

  @override
  void initState() {
    super.initState();
    gymsStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    gymsStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Map gymDetails = {
    //   "name": "Fitstop Gym",
    //   "location": "Labim Mall, Lalitpur",
    //   "time": "07:00AM - 12:00PM",
    //   "imageURL": "https://images.unsplash.com/photo-1570829460005-c840387bb1ca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGd5bXxlbnwwfHwwfHw%3D&w=1000&q=80",
    // };

    List<Map> gymsDetails = [
      {
        "name": "Fitstop Gym",
        "location": "Labim Mall, Lalitpur",
        "time": "07:00AM - 12:00PM",
        "imageURL":
            "https://media.istockphoto.com/photos/empty-gym-picture-id1132006407?k=20&m=1132006407&s=612x612&w=0&h=Z7nJu8jntywb9jOhvjlCS7lijbU4_hwHcxoVkxv77sg=",
        "description":
            "What is a gym? A gym - physical exercises and activities performed inside, often using equipment, especially when done as a subject at school. Gymnasium is a large room with equipment for exercising the body and increasing strength or a club where you can go to exercise and keep fit.",
      },
      {
        "name": "NoFitGo Gym",
        "location": "Kamaladi Mall, Kamaladi",
        "time": "07:00AM - 11:00PM",
        "imageURL":
            "https://images.unsplash.com/photo-1570829460005-c840387bb1ca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzB8fGd5bXxlbnwwfHwwfHw%3D&w=1000&q=80",
        "description":
            "What is a gym? A gym - physical exercises and activities performed inside, often using equipment, especially when done as a subject at school. Gymnasium is a large room with equipment for exercising the body and increasing strength or a club where you can go to exercise and keep fit.",
      }
    ];

    // return



    return GymSection(gymsStream);
  }

}
