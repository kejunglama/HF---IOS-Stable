import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/components/nothingtoshow_container.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/screens/edit_address/edit_address_screen.dart';
import 'package:healthfix/screens/manage_addresses/components/address_short_details_card.dart';
import 'package:healthfix/services/data_streams/addresses_stream.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import '../components/address_box.dart';

class Body extends StatefulWidget {
  final bool isSelectAddressScreen;

  Body(this.isSelectAddressScreen);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AddressesStream addressesStream = AddressesStream();

  @override
  void initState() {
    super.initState();
    addressesStream.init();
  }

  @override
  void dispose() {
    super.dispose();
    addressesStream.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: refreshPage,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    widget.isSelectAddressScreen
                        ? "Select Address"
                        : "Manage Addresses",
                    style: cusHeadingStyle(
                        fontSize: getProportionateScreenHeight(28)),
                  ),
                  SizedBox(height: getProportionateScreenHeight(4)),
                  Text("Swipe LEFT to Edit, Swipe RIGHT to Delete",
                      style: cusBodyStyle(getProportionateScreenHeight(12))),
                  Visibility(
                    visible: !widget.isSelectAddressScreen,
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(20)),
                        DefaultButton(
                          text: "Add New Address",
                          press: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAddressScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.7,
                    child: StreamBuilder<List<String>>(
                      stream: addressesStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final addresses = snapshot.data;
                          if (addresses.length == 0) {
                            return Center(
                              child: NothingToShowContainer(
                                iconPath: "assets/icons/add_location.svg",
                                secondaryMessage: "Add your first Address",
                              ),
                            );
                          }
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: addresses.length,
                              itemBuilder: (context, index) {
                                return buildAddressItemCard(addresses[index],
                                    widget.isSelectAddressScreen);
                              });
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(50)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshPage() {
    addressesStream.reload();
    return Future<void>.value();
  }

  Future<bool> deleteButtonCallback(
      BuildContext context, String addressId) async {
    final confirmDeletion = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text("Confirmation"),
          content: Text(
            "Are you sure you want to delete this Address ?",
            style: TextStyle(fontSize: getProportionateScreenHeight(16)),
          ),
          actions: [
            TextButton(
              child: Text(
                "Delete",
                style: TextStyle(
                    fontSize: getProportionateScreenHeight(16),
                    color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: getProportionateScreenHeight(16)),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );

    if (confirmDeletion) {
      bool status = false;
      String snackbarMessage;
      try {
        status =
            await UserDatabaseHelper().deleteAddressForCurrentUser(addressId);
        if (status == true) {
          snackbarMessage = "Address deleted successfully";
        } else {
          throw "Coulnd't delete address due to unknown reason";
        }
      } on FirebaseException catch (e) {
        Logger().w("Firebase Exception: $e");
        snackbarMessage = "Something went wrong";
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
      await refreshPage();
      return status;
    }
    return false;
  }

  Future<bool> editButtonCallback(
      BuildContext context, String addressId) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditAddressScreen(addressIdToEdit: addressId)));
    await refreshPage();
    return false;
  }

  Future<void> addressItemTapCallback(String addressId,
      [bool isSelectAddressScreen]) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Colors.transparent,
          title: AddressBox(
            addressId: addressId,
            isSelectAddressScreen: isSelectAddressScreen,
          ),
          titlePadding: EdgeInsets.zero,
        );
      },
    );
    await refreshPage();
  }

  Widget buildAddressItemCard(String addressId, bool isSelectAddressScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Dismissible(
        key: Key(addressId),
        direction: DismissDirection.horizontal,
        background: buildDismissibleSecondaryBackground(),
        secondaryBackground: buildDismissiblePrimaryBackground(),
        dismissThresholds: {
          DismissDirection.endToStart: 0.65,
          DismissDirection.startToEnd: 0.65,
        },
        child: AddressShortDetailsCard(
          addressId: addressId,
          onTap: () async {
            await addressItemTapCallback(addressId, isSelectAddressScreen);
          },
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            final status = await deleteButtonCallback(context, addressId);
            return status;
          } else if (direction == DismissDirection.endToStart) {
            final status = await editButtonCallback(context, addressId);
            return status;
          }
          return false;
        },
        onDismissed: (direction) async {
          await refreshPage();
        },
      ),
    );
  }

  Widget buildDismissiblePrimaryBackground() {
    return Container(
      padding: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.edit,
            size: getProportionateScreenHeight(20),
            color: Colors.white,
          ),
          SizedBox(width: getProportionateScreenWidth(4)),
          Text(
            "Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenHeight(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDismissibleSecondaryBackground() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenHeight(15),
            ),
          ),
          SizedBox(width: getProportionateScreenWidth(4)),
          Icon(
            Icons.delete,
            size: getProportionateScreenHeight(20),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
