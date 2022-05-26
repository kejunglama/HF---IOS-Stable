import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthfix/models/Gym.dart';
import 'package:healthfix/models/GymSubscription.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../utils.dart';

class Body extends StatefulWidget {
  Gym gym;

  Body(this.gym);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Map> services = [
    {"name": "Certified\nSupervision", "icon": Icons.supervised_user_circle_outlined},
    {"name": "Diet\nConsultation", "icon": Icons.no_food_outlined},
    {"name": "Hot/Cold\nBath & Sauna", "icon": Icons.bathtub_outlined},
    {"name": "Routine\nExercise", "icon": Icons.calendar_today_rounded},
    {"name": "Water\nSupply", "icon": Icons.hourglass_bottom_outlined},
  ];

  // List<Map> packages = [
  //   {"duration": "30-Days", "price": "8000"},
  //   {"duration": "3-Mnths", "price": "22000"},
  //   {"duration": "1-Year", "price": "92000"},
  // ];

  static const String LOCATION_NAME_KEY = "address";
  static const String LOCATION_LINK_KEY = "map_link";
  static const String PACKAGES_DURATION_KEY = "duration";
  static const String PACKAGES_PRICE_KEY = "price";

  num selectedPackageIndex = -1;
  String selectedDate = "${now.day}-${now.month}-${now.year}";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              // _______________________________________________
              // Image
              Container(
                height: getProportionateScreenHeight(300),
                width: double.infinity,
                child: Image.network(
                  widget.gym.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              // _______________________________________________
              // Heading Information
              Container(
                padding: EdgeInsets.fromLTRB(getProportionateScreenWidth(24), getProportionateScreenWidth(24), getProportionateScreenWidth(24),
                    getProportionateScreenWidth(12)),
                margin: EdgeInsets.only(bottom: getProportionateScreenWidth(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.gym.name, style: cusHeadingStyle(25)),
                        Text("Opening Time: ${widget.gym.openingTime}", style: GoogleFonts.poppins()),
                        // Text(gymDetails["time"], style: GoogleFonts.poppins(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => launch(widget.gym.location[LOCATION_LINK_KEY]),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: kPrimaryColor,
                            size: 16,
                          ),
                          sizedBoxOfWidth(4),
                          Container(child: Text(widget.gym.location[LOCATION_NAME_KEY], style: cusHeadingLinkStyle)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(24)),
                child: Divider(height: getProportionateScreenHeight(4), thickness: 0.5, color: Colors.grey.shade300),
              ),
              // _______________________________________________
              // Services
              Container(
                height: getProportionateScreenHeight(94),
                // width: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: [
                    for (Map service in services) buildService(service),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(24)),
                child: Divider(height: getProportionateScreenHeight(4), thickness: 0.5, color: Colors.grey.shade300),
              ),
              // _______________________________________________
              // Descriptions
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(24)),
              //   width: double.infinity,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Information", style: cusHeadingStyle()),
              //       sizedBoxOfHeight(8),
              //       Text(widget.gymDetails["description"], style: cusBodyStyle()),
              //     ],
              //   ),
              // ),
              // ToggleTabs(),
              // _______________________________________________
              // Description
              Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(24.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Information", style: cusHeadingStyle(getProportionateScreenHeight(20))),
                    sizedBoxOfHeight(getProportionateScreenHeight(12)),
                    Text(
                      widget.gym.desc,
                      style: cusBodyStyle(),
                    ),
                  ],
                ),
              ),
              // _______________________________________________
              // Packages List
              buildPackagesList(widget.gym.packages),
              sizedBoxOfHeight(80),
            ],
          ),
        ),

        // _______________________________________________
        // Price
        Visibility(
          visible: selectedPackageIndex >= 0,
          child: Positioned(
            // left: 0,
            bottom: 0,
            child: Container(
              margin: EdgeInsets.all(getProportionateScreenWidth(12)),
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth - getProportionateScreenWidth(24),
              height: getProportionateScreenHeight(48),
              decoration: BoxDecoration(color: kPrimaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text.rich(
                          TextSpan(
                            text: "Starting From:\n",
                            style: cusBodyStyle(16, null, Colors.white),
                            children: [
                              TextSpan(
                                text: "$selectedDate  ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "Change",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showDatePickerPopup();
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () async {
                        bool allowed = AuthentificationService().currentUserVerified;
                        if (!allowed) {
                          final reverify = await showConfirmationDialog(
                              context, "You haven't verified your email address. This action is only allowed for verified users.",
                              positiveResponse: "Resend verification email", negativeResponse: "Go back");
                          if (reverify) {
                            final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return FutureProgressDialog(
                                  future,
                                  message: Text("Resending verification email"),
                                );
                              },
                            );
                          }
                          return;
                        }
                        bool addedSuccessfully = false;
                        String snackbarMessage;
                        GymSubscription gymSubscription = GymSubscription(
                          gymID: widget.gym.id,
                          gymName: widget.gym.name,
                          package: widget.gym.packages[selectedPackageIndex],
                          startingFrom: selectedDate,
                          subscribedOn: "${now.day}-${now.month}-${now.year}",
                        );
                        try {
                          addedSuccessfully = await UserDatabaseHelper().addGymSubscriptionForCurrentUser(gymSubscription);
                          if (addedSuccessfully == true) {
                            snackbarMessage = "Gym Subscription Added successfully";
                          } else {
                            throw "Couldn't add Gym Subscription due to unknown reason";
                          }
                        } on FirebaseException catch (e) {
                          Logger().w("Firebase Exception: $e");
                          snackbarMessage = "Something went wrong";
                        } catch (e) {
                          Logger().w("Unknown Exception: $e");
                          snackbarMessage = "Something went wrong";
                        } finally {
                          Logger().i(snackbarMessage);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(snackbarMessage),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Book Today →",
                        style: cusHeadingStyle(18, Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPackagesList(List packages) {
    List<Widget> list = [];
    for (var i = 0; i < packages.length; i++) {
      list.add(buildPackage(packages[i], i));
    }
    // list = packages.asMap().map((i, e) => MapEntry(i, buildPackage(packages[i], i))).values.toList();

    return Container(
      // margin: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(16)),
      height: getProportionateScreenHeight(36),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: list,
      ),
    );
  }

  Container buildService(Map service) {
    return Container(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(24), right: getProportionateScreenWidth(12)),
      // margin: EdgeInsets.only(right: getProportionateScreenWidth(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(service["icon"], size: 36, color: Colors.grey),
          sizedBoxOfHeight(8),
          Text(
            service["name"],
            style: cusBodyStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget buildPackage(Map package, num i) {
    var curFormat = new NumberFormat.currency(locale: "en_US", symbol: "Rs. ", decimalDigits: 0);
    bool isSelected = selectedPackageIndex == i ?? false;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPackageIndex = i;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16), vertical: getProportionateScreenHeight(4)),
        margin: EdgeInsets.only(left: getProportionateScreenWidth(24)),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: isSelected ? kPrimaryColor : kPrimaryColor.withOpacity(0.08),
          ),
          color: kPrimaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(
          "${package[PACKAGES_DURATION_KEY]} for ${curFormat.format((package[PACKAGES_PRICE_KEY]))}",
          style: TextStyle(color: kPrimaryColor),
        )),
      ),
    );
  }

  DateTime _chosenDateTime;

  // Show the modal that contains the CupertinoDatePicker
  void showDatePickerPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          title: Container(
            width: getProportionateScreenWidth(300),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                Text(
                  "Choose your Start Date",
                  style: cusHeadingStyle(),
                ),
                sizedBoxOfHeight(12),
                Container(
                  height: getProportionateScreenHeight(240),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: now,
                    maximumYear: now.year + 1,
                    minimumDate: now,
                    minimumYear: now.year,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        selectedDate = "${newDate.day}-${newDate.month}-${newDate.year}";
                      });
                    },
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    "Select Start Date",
                    style: GoogleFonts.poppins(letterSpacing: 1),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
          titlePadding: EdgeInsets.zero,
        );
      },
    );
  }
}
