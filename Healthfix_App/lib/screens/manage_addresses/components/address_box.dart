import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Address.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

class AddressBox extends StatelessWidget {
  final bool isSelectAddressScreen;

  AddressBox({
    Key key,
    @required this.addressId,
    this.isSelectAddressScreen,
  }) : super(key: key);

  final String addressId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: SizeConfig.screenWidth,
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: FutureBuilder<Address>(
                  future: UserDatabaseHelper().getAddressFromId(addressId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final address = snapshot.data;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${address.title} Address",
                            style: cusHeadingStyle(
                                fontSize: getProportionateScreenHeight(20),
                                color: kSecondaryColor),
                          ),
                          sizedBoxOfHeight(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Receiver's Name: ",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16))),
                              Text("${address.receiver}",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          sizedBoxOfHeight(8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Address: ",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16))),
                              Text("${address.address}",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          sizedBoxOfHeight(8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Landmark: ",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16))),
                              Text("${address.landmark}",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          sizedBoxOfHeight(8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("City: ",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16))),
                              Text("${address.city}, ${address.zone}",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                          sizedBoxOfHeight(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Contact: ",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16))),
                              Text("${address.phone}",
                                  style: cusBodyStyle(
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),

                          sizedBoxOfHeight(20),
                          Visibility(
                            visible: isSelectAddressScreen ?? false,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pop(context, address);
                                // print(address.runtimeType);
                              },
                              child: Text(
                                "Select Address",
                                style: cusBodyStyle(
                                    fontSize: getProportionateScreenHeight(16),
                                    fontWeight: FontWeight.w500,
                                    color: kPrimaryColor),
                              ),
                            ),
                          ),
                          // DefaultButton(text: ,color: kPrimaryColor, press: (){},),
                        ],
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
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
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
