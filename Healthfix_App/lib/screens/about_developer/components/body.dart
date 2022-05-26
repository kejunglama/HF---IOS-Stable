import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/AppReview.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/app_review_database_helper.dart';
import 'package:healthfix/services/firestore_files_access/firestore_files_access_service.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_review_dialog.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding),
          ),
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBoxOfHeight(120),
                InkWell(
                  onTap: () async {
                    const String linkedInUrl = "https://www.siteux.gq";
                    await launchUrl(linkedInUrl);
                  },
                  child: Container(
                    height: SizeConfig.screenWidth * 0.4,
                    width: SizeConfig.screenWidth * 0.4,
                    child: Image.asset('assets/logo/logo-SITEUX.png'),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  'SiteUX Developers',
                  style: cusCenterHeadingStyle(),
                ),
                Text(
                  "Kupondole Heights, Kathmandu",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Row(
                  children: [
                    Spacer(),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/facebook.svg", color: Color(0xff4182CB)),
                      iconSize: 50,
                      padding: EdgeInsets.all(8),
                      onPressed: () async {
                        const String url = "https://facebook.com/siteux.np";
                        await launch(url, forceSafariVC: false);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/instagram.svg", color: Color(0xff4182CB)),
                      iconSize: 50,
                      padding: EdgeInsets.all(8),
                      onPressed: () async {
                        const String url = "https://instagram.com/siteux.np";
                        await launch(url, forceSafariVC: false);
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/link.svg", color: Color(0xff4182CB)),
                      iconSize: 50,
                      padding: EdgeInsets.all(8),
                      onPressed: () async {
                        const String url = "https://siteux.gq";
                        await launch(url, forceSafariVC: false);
                      },
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.thumb_up_alt_rounded),
                      color: Colors.blue.withOpacity(0.75),
                      iconSize: 32,
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        submitAppReview(context, liked: true);
                      },
                    ),
                    Text(
                      "Liked the app?",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down_alt_rounded),
                      padding: EdgeInsets.all(16),
                      color: Colors.blue.withOpacity(0.75),
                      iconSize: 32,
                      onPressed: () {
                        submitAppReview(context, liked: false);
                      },
                    ),
                    Spacer(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperAvatar() {
    return FutureBuilder<String>(
        future: FirestoreFilesAccess().getDeveloperImage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final url = snapshot.data;
            return CircleAvatar(
              radius: SizeConfig.screenWidth * 0.3,
              backgroundColor: kTextColor.withOpacity(0.75),
              foregroundImage: Image.asset('assets/logo/HF-logo.png').image,
            );
          } else if (snapshot.hasError) {
            final error = snapshot.error.toString();
            Logger().e(error);
          }
          return CircleAvatar(
            radius: SizeConfig.screenWidth * 0.3,
            backgroundColor: kTextColor.withOpacity(0.75),
          );
        });
  }

  Future<void> launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Logger().i("LinkedIn URL was unable to launch");
      }
    } catch (e) {
      Logger().e("Exception while launching URL: $e");
    }
  }

  Future<void> submitAppReview(BuildContext context, {bool liked = true}) async {
    AppReview prevReview;
    try {
      prevReview = await AppReviewDatabaseHelper().getAppReviewOfCurrentUser();
    } on FirebaseException catch (e) {
      Logger().w("Firebase Exception: $e");
    } catch (e) {
      Logger().w("Unknown Exception: $e");
    } finally {
      if (prevReview == null) {
        prevReview = AppReview(
          AuthentificationService().currentUser.uid,
          liked: liked,
          feedback: "",
        );
      }
    }

    final AppReview result = await showDialog(
      context: context,
      builder: (context) {
        return AppReviewDialog(
          appReview: prevReview,
        );
      },
    );
    if (result != null) {
      result.liked = liked;
      bool reviewAdded = false;
      String snackbarMessage;
      try {
        reviewAdded = await AppReviewDatabaseHelper().editAppReview(result);
        if (reviewAdded == true) {
          snackbarMessage = "Feedback submitted successfully";
        } else {
          throw "Coulnd't add feeback due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = e.toString();
      } catch (e) {
        Logger().w("Unknown Exception: $e");
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}
