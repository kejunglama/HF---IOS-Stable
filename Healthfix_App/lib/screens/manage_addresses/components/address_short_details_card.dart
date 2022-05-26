import 'package:healthfix/constants.dart';
import 'package:healthfix/models/Address.dart';
import 'package:healthfix/services/database/user_database_helper.dart';
import 'package:healthfix/size_config.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddressShortDetailsCard extends StatelessWidget {
  final String addressId;
  final Function onTap;

  const AddressShortDetailsCard(
      {Key key, @required this.addressId, @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: SizeConfig.screenHeight * 0.10,
        child: FutureBuilder<Address>(
          future: UserDatabaseHelper().getAddressFromId(addressId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final address = snapshot.data;
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.75),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          address.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan.withOpacity(0.24),),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            address.receiver,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text("${address.landmark}"),
                          Row(
                            children: [
                              Text("${address.address}, "),
                              Text("${address.city}"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              final error = snapshot.error.toString();
              Logger().e(error);
            }
            return Center(
              child: Icon(
                Icons.error,
                size: 40,
                color: kTextColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
