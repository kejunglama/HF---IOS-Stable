import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/about_developer/about_developer_screen.dart';
import 'package:healthfix/screens/change_email/change_email_screen.dart';
import 'package:healthfix/screens/change_password/change_password_screen.dart';
import 'package:healthfix/screens/edit_product/edit_product_screen.dart';
import 'package:healthfix/screens/home/home_screen.dart';
import 'package:healthfix/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:healthfix/screens/my_gym_subscriptions/my_gym_subscriptions_screen.dart';
import 'package:healthfix/screens/my_orders/my_orders_screen.dart';
import 'package:healthfix/screens/my_products/my_products_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/shared_preference.dart';
import 'package:healthfix/size_config.dart';
import 'package:healthfix/utils.dart';
import 'package:logger/logger.dart';

import '../../change_display_name/change_display_name_screen.dart';

class HomeScreenDrawer extends StatelessWidget {
  const HomeScreenDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Account",
          style: cusCenterHeadingStyle(),
        ),
        // leading: BackButton(
        //   color: kPrimaryColor,
        // ),
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            buildUserAccountsHeader(context),
            Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  CardDesign(child: buildEditAccountExpansionTile(context)),
                  CardDesign(
                    child: ListTile(
                      leading: Icon(Icons.map_outlined, color: kSecondaryColor),
                      title: Text(
                        "My Addresses",
                        style: cusHeadingStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenHeight(14),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.6,
                        ),
                      ),
                      onTap: () async {
                        bool allowed = AuthentificationService().currentUserVerified;
                        if (!allowed) {
                          final reverify = await showConfirmationDialog(context,
                              "You haven't verified your email address. This action is only allowed for verified users.",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageAddressesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  CardDesign(
                    child: ListTile(
                      leading: Icon(Icons.shopping_bag_outlined, color: kSecondaryColor),
                      title: Text(
                        "My Orders",
                        style: cusHeadingStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenHeight(14),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.6,
                        ),
                      ),
                      onTap: () async {
                        bool allowed = AuthentificationService().currentUserVerified;
                        if (!allowed) {
                          final reverify = await showConfirmationDialog(context,
                              "You haven't verified your email address. This action is only allowed for verified users.",
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrdersScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  // CardDesign(
                  //   child: ListTile(
                  //     leading: Icon(Icons.fitness_center, color: kSecondaryColor),
                  //     title: Text(
                  //       "Gym Subscriptions",
                  //       style: TextStyle(color: Colors.black, fontSize: getProportionateScreenHeight(16)),
                  //     ),
                  //     onTap: () async {
                  //       bool allowed = AuthentificationService().currentUserVerified;
                  //       if (!allowed) {
                  //         final reverify = await showConfirmationDialog(context,
                  //             "You haven't verified your email address. This action is only allowed for verified users.",
                  //             positiveResponse: "Resend verification email", negativeResponse: "Go back");
                  //         if (reverify) {
                  //           final future = AuthentificationService().sendVerificationEmailToCurrentUser();
                  //           await showDialog(
                  //             context: context,
                  //             builder: (context) {
                  //               return FutureProgressDialog(
                  //                 future,
                  //                 message: Text("Resending verification email"),
                  //               );
                  //             },
                  //           );
                  //         }
                  //         return;
                  //       }
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => MyGymSubscriptionsScreen(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  // // CardDesign(child: buildSellerExpansionTile(context)),
                  CardDesign(
                    child: ListTile(
                      leading: Icon(Icons.info_outline, color: kSecondaryColor),
                      title: Text(
                        "About Developer",
                        style: cusHeadingStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenHeight(14),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.6,
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AboutDeveloperScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  CardDesign(
                    child: ListTile(
                      leading: Icon(Icons.logout, color: kSecondaryColor),
                      title: Text(
                        "Sign out",
                        style: cusHeadingStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenHeight(14),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.6,
                        ),
                      ),
                      onTap: () async {
                        final confirmation = await showConfirmationDialog(context, "Confirm Sign out ?");
                        if (confirmation) {
                          UserPreferences prefs = new UserPreferences();
                          prefs.reset();
                          AuthentificationService().signOut();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) => name.isNotEmpty ? name.trim().split(' ').map((l) => l[0]).take(2).join() : 'HF';

  Widget buildUserAccountsHeader(BuildContext context) {
    // UserPreferences prefs = new UserPreferences();
    // Map user;
    User user = AuthentificationService().currentUser;
    print(user);
    Widget avatar = user.photoURL == null
        ? CircleAvatar(child: Text(getInitials(user.displayName)))
        : CircleAvatar(
            backgroundImage: NetworkImage(user.photoURL),
          );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          // color: kTextColor.withOpacity(0.16),
          ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Camera
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: kPrimaryColor.withOpacity(0.2)),
                ),
                child: IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ChangeDisplayPictureScreen(),
                    //     ));
                  },
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: kPrimaryColor.withOpacity(0.6),
                  ),
                ),
              ),
              // pp
              Column(
                children: [
                  Container(
                      height: getProportionateScreenHeight(100),
                      width: getProportionateScreenHeight(100),
                      margin: EdgeInsets.all(getProportionateScreenHeight(20)),
                      child: avatar),
                  buildUserNameWidget(user),
                ],
              ),
              // FutureBuilder(
              //   future: prefs.getUser(),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       user = snapshot.data;
              //       print(snapshot.data);
              //       print("snapshot.data");
              //       Widget avatar = user["display_image"] == null
              //           ? CircleAvatar(child: Text(getInitials(user["display_image"])))
              //           : CircleAvatar(
              //               backgroundImage: NetworkImage(user["display_image"]),
              //             );
              //       ;
              //       return Column(
              //         children: [
              //           Container(
              //               height: getProportionateScreenHeight(100),
              //               width: getProportionateScreenHeight(100),
              //               margin: EdgeInsets.all(getProportionateScreenHeight(20)),
              //               child: avatar),
              //           buildUserNameWidget(user),
              //         ],
              //       );
              //     } else if (snapshot.connectionState == ConnectionState.waiting) {
              //       return Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     } else if (snapshot.hasError) {
              //       final error = snapshot.error;
              //       Logger().w(error.toString());
              //     }
              //     return Column(
              //       children: [
              //         // CircleAvatar(
              //         //     // backgroundColor: kTextColor,
              //         //     backgroundColor: kPrimaryColor.withOpacity(0.2),
              //         //     child: Text(getInitials("Health Fix"))),
              //         CircularProgressIndicator(),
              //       ],
              //     );
              //   },
              // ),
              // Logout
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: kPrimaryColor.withOpacity(0.2)),
                ),
                child: IconButton(
                  onPressed: () async {
                    final confirmation = await showConfirmationDialog(
                      context,
                      "Are you sure you want to Log out?",
                      positiveResponse: "Log Out",
                      negativeResponse: "Stay",
                    );
                    if (confirmation) {
                      UserPreferences prefs = new UserPreferences();
                      prefs.reset();
                      AuthentificationService().signOut();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    }
                    ;
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    color: kPrimaryColor.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // UserAccountsDrawerHeader(
    //   margin: EdgeInsets.zero,
    //   decoration: BoxDecoration(
    //     color: kTextColor.withOpacity(0.16),
    //
    //   ),
    //   accountEmail: Text(
    //     user.email ?? "No Email",
    //     style: TextStyle(
    //       fontSize: getProportionateScreenHeight(16),
    //       color: Colors.black,
    //     ),
    //   ),
    //   accountName: Text(
    //     user.displayName ?? "No Name",
    //     style: TextStyle(
    //       fontSize: 18,
    //       fontWeight: FontWeight.w500,
    //       color: Colors.black,
    //     ),
    //   ),
    //   currentAccountPicture: FutureBuilder(
    //     future: UserDatabaseHelper().displayPictureForCurrentUser,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return CircleAvatar(
    //           backgroundImage: NetworkImage(snapshot.data),
    //         );
    //       } else if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (snapshot.hasError) {
    //         final error = snapshot.error;
    //         Logger().w(error.toString());
    //       }
    //       return CircleAvatar(
    //         // backgroundColor: kTextColor,
    //           backgroundColor: kPrimaryColor.withOpacity(0.2),
    //           child: Text('HF')
    //       );
    //     },
    //   ),
    // );
  }

  Column buildUserNameWidget(User user) {
    return Column(
      children: [
        Visibility(
          visible: user.displayName.isNotEmpty,
          child: Text(
            user.displayName,
            style: cusHeadingStyle(
              fontSize: getProportionateScreenHeight(18),
              color: kSecondaryColor,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Text(
          user.email ?? "No Email",
          style: user.email.isNotEmpty
              ? cusBodyStyle(
                  fontSize: getProportionateScreenHeight(12),
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.5,
                )
              : cusHeadingStyle(fontSize: getProportionateScreenHeight(22), color: kPrimaryColor),
        ),
      ],
    );
  }

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.account_circle_rounded, color: kSecondaryColor),
      title: Text(
        "Account Details",
        style: cusHeadingStyle(
          color: Colors.black,
          fontSize: getProportionateScreenHeight(14),
          fontWeight: FontWeight.w300,
          letterSpacing: 0.6,
        ),
      ),
      children: [
        // ListTile(
        //   title: Text(
        //     "Change Display Picture",
        //     style: TextStyle(
        //       color: Colors.black,
        //       fontSize: getProportionateScreenHeight(16),
        //     ),
        //   ),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => ChangeDisplayPictureScreen(),
        //         ));
        //   },
        // ),
        ListTile(
          title: Text(
            "Change Display Name",
            style: cusHeadingStyle(
              color: Colors.black,
              fontSize: getProportionateScreenHeight(14),
              fontWeight: FontWeight.w300,
              letterSpacing: 0.6,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDisplayNameScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Phone Number",
            style: cusHeadingStyle(
              color: Colors.black,
              fontSize: getProportionateScreenHeight(14),
              fontWeight: FontWeight.w300,
              letterSpacing: 0.6,
            ),
          ),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ChangePhoneScreen(),
            //     ));
          },
        ),
        ListTile(
          title: Text(
            "Change Email",
            style: cusHeadingStyle(
              color: Colors.black,
              fontSize: getProportionateScreenHeight(14),
              fontWeight: FontWeight.w300,
              letterSpacing: 0.6,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeEmailScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Password",
            style: cusHeadingStyle(
              color: Colors.black,
              fontSize: getProportionateScreenHeight(14),
              fontWeight: FontWeight.w300,
              letterSpacing: 0.6,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ));
          },
        ),
      ],
    );
  }

  Widget buildSellerExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.verified_outlined, color: kSecondaryColor),
      title: Text(
        "Vendor",
        style: cusPdctNameStyle(),
      ),
      children: [
        ListTile(
          title: Text(
            "Add New Product",
            style: TextStyle(
              color: Colors.black,
              fontSize: getProportionateScreenHeight(16),
            ),
          ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen()));
          },
        ),
        ListTile(
          title: Text(
            "Manage My Products",
            style: TextStyle(
              color: Colors.black,
              fontSize: getProportionateScreenHeight(16),
            ),
          ),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyProductsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CardDesign extends StatelessWidget {
  final Widget child;

  CardDesign({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryColor.withOpacity(0.05),
      ),
      child: child,
    );
  }
}
