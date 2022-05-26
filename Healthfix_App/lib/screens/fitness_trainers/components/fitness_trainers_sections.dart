import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/services/data_streams/trainers_stream.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'fitness_trainer_details_card.dart';

class FitnessTrainersSection extends StatelessWidget {
  final TrainersStream trainersStreamController;
  final String emptyListMessage;

  FitnessTrainersSection(
    this.trainersStreamController, {
    this.emptyListMessage = "No Products to show here",
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: trainersStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(secondaryMessage: emptyListMessage),
            );
          }
          return buildTrainersGrid(snapshot.data);
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

  Widget buildTrainersGrid(List<String> trainerIDs) {
    return Column(
      children: [
        buildHeader(),
        sizedBoxOfHeight(28),
        // Card Lists
        Column(
          children: [for (String trainerID in trainerIDs) FitnessTrainerDetailsCard(trainerID)],
        ),
      ],
    );
  }

  String name = "Sadikshya Vaidya";
  String title = "Certified Trainer/Nutritionist";
  String experience = "8 years of Experience as a Trainer";
  String availableTime = "09:45AM";

  Widget DetailsCard(trainerID) {
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
                    ),
                  ),
                  sizedBoxOfWidth(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: cusHeadingStyle(20)),
                      Text(title, style: cusHeadingStyle(16, Colors.blue, null, FontWeight.w400)),
                      sizedBoxOfHeight(8),
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                          sizedBoxOfWidth(4),
                          Text(experience, style: cusBodyStyle(null, null, Colors.black54)),
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
                          Text("Next Available Time: $availableTime", style: cusBodyStyle(null, null, Colors.black54)),
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
  }

  Column buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & Sub-title
        Container(
          padding: EdgeInsets.all(getProportionateScreenHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Popular Trainer", style: cusHeadingStyle(28)),
              Text("in Kathmandu", style: cusHeadingStyle()),
              sizedBoxOfHeight(8),
            ],
          ),
        ),
        Row(
          children: [
            // Search Field
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(12)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade100,
                ),
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                  height: getProportionateScreenHeight(40),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: Colors.grey, size: getProportionateScreenHeight(20)),
                      Container(
                        margin: EdgeInsets.only(left: getProportionateScreenWidth(10)),
                        child: Text(
                          "Search Products, Brands, Vendors",
                          style: cusHeadingStyle(14, Colors.grey, null, FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Filter Btn
            Container(
              height: getProportionateScreenHeight(40),
              // margin: EdgeInsets.only(right: getProportionateScreenHeight(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: kPrimaryColor,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list_rounded),
                color: Colors.white,
              ),
            ),
            sizedBoxOfWidth(12),
          ],
        ),
      ],
    );
  }
}
