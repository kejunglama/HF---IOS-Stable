import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/about_developer/about_developer_screen.dart';
import 'package:healthfix/screens/change_display_picture/change_display_picture_screen.dart';
import 'package:healthfix/screens/change_email/change_email_screen.dart';
import 'package:healthfix/screens/change_password/change_password_screen.dart';
import 'package:healthfix/screens/change_phone/change_phone_screen.dart';
import 'package:healthfix/screens/edit_product/edit_product_screen.dart';
import 'package:healthfix/screens/manage_addresses/manage_addresses_screen.dart';
import 'package:healthfix/screens/my_gym_subscriptions/my_gym_subscriptions_screen.dart';
import 'package:healthfix/screens/my_orders/my_orders_screen.dart';
import 'package:healthfix/screens/my_products/my_products_screen.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/shared_preference.dart';
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
      ),
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            StreamBuilder<User>(
                stream: AuthentificationService().userChanges,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return buildUserAccountsHeader(user, context);
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Icon(Icons.error),
                    );
                  }
                }),
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
                        style: cusPdctNameStyle,
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
                        style: cusPdctNameStyle,
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
                            builder: (context) => MyOrdersScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  CardDesign(
                    child: ListTile(
                      leading: Icon(Icons.fitness_center, color: kSecondaryColor),
                      title: Text(
                        "Gym Subscriptions",
                        style: cusPdctNameStyle,
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
                            builder: (context) => MyGymSubscriptionsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  // CardDesign(child: buildSellerExpansionTile(context)),
                  CardDesign(
                    child: ListTile(
                      leading: Icon(Icons.info_outline, color: kSecondaryColor),
                      title: Text(
                        "About Developer",
                        style: cusPdctNameStyle,
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
                        style: cusPdctNameStyle,
                      ),
                      onTap: () async {
                        final confirmation = await showConfirmationDialog(context, "Confirm Sign out ?");
                        if (confirmation) {
                          UserPreferences prefs = new UserPreferences();
                          prefs.reset();
                          AuthentificationService().signOut();
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

  Widget buildUserAccountsHeader(User user, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
          // color: kTextColor.withOpacity(0.15),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeDisplayPictureScreen(),
                        ));
                  },
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    color: kPrimaryColor.withOpacity(0.6),
                  ),
                ),
              ),
              // pp
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.all(30),
                child: FutureBuilder(
                  future: UserDatabaseHelper().displayPictureForCurrentUser,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        backgroundImage: NetworkImage(snapshot.data),
                      );
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      final error = snapshot.error;
                      Logger().w(error.toString());
                    }
                    return CircleAvatar(
                        // backgroundColor: kTextColor,
                        backgroundColor: kPrimaryColor.withOpacity(0.2),
                        child: Text('HF'));
                  },
                ),
              ),
              // Logout
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 1, color: kPrimaryColor.withOpacity(0.2)),
                ),
                child: IconButton(
                  onPressed: () async {
                    final confirmation = await showConfirmationDialog(context, "Confirm Sign out ?");
                    if (confirmation) AuthentificationService().signOut();
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    color: kPrimaryColor.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: user.displayName.isNotEmpty,
            child: Text(
              user.displayName,
              style: cusHeadingStyle(22, kPrimaryColor),
            ),
          ),
          Text(
            user.email ?? "No Email",
            style: user.displayName.isNotEmpty
                ? TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  )
                : cusHeadingStyle(22, kPrimaryColor),
          ),
        ],
      ),
    );
    // UserAccountsDrawerHeader(
    //   margin: EdgeInsets.zero,
    //   decoration: BoxDecoration(
    //     color: kTextColor.withOpacity(0.15),
    //
    //   ),
    //   accountEmail: Text(
    //     user.email ?? "No Email",
    //     style: TextStyle(
    //       fontSize: 15,
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

  ExpansionTile buildEditAccountExpansionTile(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.account_box_outlined, color: kSecondaryColor),
      title: Text(
        "Account Details",
        style: cusPdctNameStyle,
      ),
      children: [
        ListTile(
          title: Text(
            "Change Display Picture",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeDisplayPictureScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Display Name",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePhoneScreen(),
                ));
          },
        ),
        ListTile(
          title: Text(
            "Change Email",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
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
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
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
        style: cusPdctNameStyle,
      ),
      children: [
        ListTile(
          title: Text(
            "Add New Product",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
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
              fontSize: 15,
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
  Widget child;

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
