import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Gym.dart';
import 'package:healthfix/screens/gym_details/gym_details_screen.dart';
import 'package:healthfix/services/database/gym_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

class GymShortDetailsCard extends StatelessWidget {
  String gymID;

  static const String LOCATION_NAME_KEY = "address";
  static const String LOCATION_LINK_KEY = "map_link";
  static const String PACKAGES_DURATION_KEY = "duration";
  static const String PACKAGES_PRICE_KEY = "price";

  GymShortDetailsCard(this.gymID);

  @override
  Widget build(BuildContext context) {
    // return NewWidget(gym: gym);
    Gym gym;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GymDetailsScreen(gym)));
      },
      child: FutureBuilder(
        future: GymDatabaseHelper().getGymWithID(gymID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            gym = snapshot.data;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: getProportionateScreenHeight(200),
                        width: double.infinity,
                        child: Image.network(
                          gym.imageURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: getProportionateScreenHeight(200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(getProportionateScreenWidth(8)),
                              margin: EdgeInsets.all(getProportionateScreenWidth(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Opening Time:", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                                  Text(gym.openingTime,
                                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                ],
                              ),
                              color: kPrimaryColor,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(12)),
                    margin: EdgeInsets.only(bottom: getProportionateScreenWidth(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(gym.name, style: cusHeadingStyle(20)),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: kPrimaryColor,
                              size: 16,
                            ),
                            sizedBoxOfWidth(4),
                            Text(gym.location[LOCATION_NAME_KEY], style: cusHeadingLinkStyle),
                          ],
                        ),
                      ],
                    ),
                  ),
                  sizedBoxOfHeight(12),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
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
