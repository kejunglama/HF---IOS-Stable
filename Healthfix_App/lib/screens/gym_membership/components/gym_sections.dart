import 'package:flutter/material.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/services/data_streams/gyms_stream.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'gym_short_details_card.dart';

class GymSection extends StatelessWidget {
  final GymsStream gymsStreamController;
  final String emptyListMessage;

  GymSection(
    this.gymsStreamController, {
    this.emptyListMessage = "No Products to show here",
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: gymsStreamController.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: NothingToShowContainer(secondaryMessage: emptyListMessage),
            );
          }
          return buildGymGrid(snapshot.data);
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

  Widget buildGymGrid(List<String> gymsIDs) {
    return Column(
      children: [
        buildHeader(),
        sizedBoxOfHeight(28),
        // Card Lists
        Column(
          children: [for (String gymID in gymsIDs) GymShortDetailsCard(gymID)],
        ),
      ],
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
              Text("Popular Gyms", style: cusHeadingStyle(28)),
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
