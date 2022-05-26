import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Trainer.dart';
import 'package:healthfix/size_config.dart';

class Body extends StatelessWidget {
  Trainer trainer;

  Body(this.trainer);

  @override
  Widget build(BuildContext context) {
    String name = trainer.name;
    String imageURL = trainer.imageURL;
    String title = trainer.title;
    String experience = trainer.experience;
    String description = trainer.description;
    String specialization = trainer.specialization;
    List timings = trainer.timings;

    String fName = name.split(' ')[0];
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: SizeConfig.screenWidth * 0.6,
                          color: Colors.blue,
                        ),
                        sizedBoxOfHeight(getProportionateScreenHeight(56)),
                        Text(name, style: cusHeadingStyle(28)),
                        // sizedBoxOfHeight(4),
                        Text(title, style: cusHeadingStyle(20, Colors.blue)),
                        sizedBoxOfHeight(8),
                        Text(experience, style: cusHeadingStyle(16, Colors.black54, null, FontWeight.w400)),
                        sizedBoxOfHeight(12),
                      ],
                    ),
                    buildAboutTrainer(fName, description, specialization, timings),
                  ],
                ),
                Positioned(
                  top: SizeConfig.screenWidth * 0.6 - getProportionateScreenHeight(60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Container(
                      width: 120,
                      height: 120,
                      color: kPrimaryColor,
                      child: Image.network(
                        imageURL,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          buildFeatures(),
        ],
      ),
    );
  }

  Widget buildAboutTrainer(String fName, String description, String specialization, List timings) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBoxOfHeight(8),
          Text("About $fName", style: cusHeadingStyle()),
          sizedBoxOfHeight(8),
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.blue, size: 16),
              sizedBoxOfWidth(4),
              Text("Specialization: ", style: cusHeadingStyle(16, Colors.blue)),
              Text(specialization, style: cusHeadingStyle(16)),
            ],
          ),
          sizedBoxOfHeight(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.schedule_rounded, color: Colors.blue, size: 16),
              sizedBoxOfWidth(4),
              Text("Available Timings: ", style: cusHeadingStyle(16, Colors.blue)),
              sizedBoxOfWidth(4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: timings.map((e) => Text(e, style: cusBodyStyle(16))).toList(),
              ),
            ],
          ),
          sizedBoxOfHeight(12),
          Row(
            children: [
              Container(
                height: getProportionateScreenHeight(56),
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("24", style: cusHeadingStyle()),
                    sizedBoxOfHeight(4),
                    Text("People Trained", style: cusPdctNameStyle),
                  ],
                ),
              ),
              sizedBoxOfWidth(8),
              Container(
                height: getProportionateScreenHeight(56),
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: RatingBar(
                        initialRating: 4.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 16,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star_rounded, color: Colors.orange),
                          half: Icon(Icons.star_half_rounded, color: Colors.orange),
                          empty: Icon(Icons.star_outline_rounded, color: Colors.orange),
                        ),
                      ),
                    ),
                    sizedBoxOfHeight(4),
                    Text("Rating: 4.5 / 5", style: cusPdctNameStyle),
                  ],
                ),
              ),
            ],
          ),
          sizedBoxOfHeight(16),
          Text(description, style: cusBodyStyle()),
        ],
      ),
    );
  }

  List<Map> features = [
    {"text": "Live Group\nSession", "icon": Icons.online_prediction_rounded},
    {"text": "Diet Plan\nConsultation", "icon": Icons.emoji_food_beverage_rounded},
    {"text": "Personal\nTraining", "icon": Icons.fitness_center_rounded},
  ];

  Widget buildFeatures() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(20)),
      color: kPrimaryColor.withOpacity(0.1),
      child: Row(
        children: features.map((e) => buildFeature(e["text"], e["icon"])).toList(),
      ),
    );
  }

  Widget buildFeature(String title, IconData icon) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            sizedBoxOfWidth(8),
            Text(title, style: cusBodyStyle(getProportionateScreenWidth(12))),
          ],
        ),
      ),
    );
  }
}
