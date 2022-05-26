import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Trainer.dart';
import 'package:healthfix/screens/fitness_trainer_details/fitness_trainer_details_screen.dart';
import 'package:healthfix/services/database/trainers_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

class FitnessTrainerDetailsCard extends StatelessWidget {
  String trainerID;

  static const String LOCATION_NAME_KEY = "address";
  static const String LOCATION_LINK_KEY = "map_link";
  static const String PACKAGES_DURATION_KEY = "duration";
  static const String PACKAGES_PRICE_KEY = "price";

  FitnessTrainerDetailsCard(this.trainerID);

  @override
  Widget build(BuildContext context) {
    // return NewWidget(gym: gym);
    Trainer trainer;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FitnessTrainerDetailsScreen(trainer)));
      },
      child: FutureBuilder(
        future: TrainersDatabaseHelper().getTrainerWithID(trainerID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            trainer = snapshot.data;
            return Container(
              padding: EdgeInsets.all(8),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black38,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 96,
                              height: 96,
                              color: Colors.blue,
                              child: Image.network(trainer.imageURL, fit: BoxFit.cover, alignment: Alignment.topCenter),
                            ),
                          ),
                          sizedBoxOfWidth(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trainer.name, style: cusHeadingStyle(20)),
                              Text(trainer.title, style: cusHeadingStyle(16, Colors.blue, null, FontWeight.w400)),
                              sizedBoxOfHeight(8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  sizedBoxOfWidth(4),
                                  Text(trainer.experience, style: cusBodyStyle(getProportionateScreenWidth(12), null, Colors.black54)),
                                ],
                              ),
                              sizedBoxOfHeight(4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  sizedBoxOfWidth(4),
                                  Text("Next Available Time: ${trainer.timings[0]}",
                                      style: cusBodyStyle(getProportionateScreenWidth(12), null, Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
            print(trainer);
          }
          return Center(
            child: Icon(
              Icons.error,
              color: kTextColor,
              size: 60,
            ),
          );
        },
      ),
    );
  }
}
