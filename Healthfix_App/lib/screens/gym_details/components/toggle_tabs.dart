import 'package:flutter/material.dart';
import 'package:healthfix/size_config.dart';

import '../../../constants.dart';

class ToggleTabs extends StatefulWidget {
  ToggleTabs({
    Key key,
  }) : super(key: key);

  @override
  State<ToggleTabs> createState() => _ToggleTabsState();
}

class _ToggleTabsState extends State<ToggleTabs> {
  num _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FlutterToggleTab(
        //   width: 50,
        //   borderRadius: 30,
        //   height: 32,
        //   selectedIndex: _selectedIndex,
        //   selectedTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        //   unSelectedTextStyle: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
        //   labels: ["Introduction", "Location"],
        //   selectedLabelIndex: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //     print("Selected Index $index");
        //   },
        //   unSelectedBackgroundColors: [Colors.white],
        //   isShadowEnable: false,
        // ),
        Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(24.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Information", style: cusHeadingStyle(getProportionateScreenHeight(20))),
              sizedBoxOfHeight(getProportionateScreenHeight(12)),
              Text(
                " A gym - physical exercises and activities performed inside, often using equipment, especially when done as a subject at school. Gymnasium is a large room with equipment for exercising the body and increasing strength or a club where you can go to exercise and keep fit. \n"
                "A gym is a gymnasium, also known as health club and fitness centre. Gymnasiums have moved away just being a location for gymnastics. Where they had gymnastics apparatus such as bar bells, parallel bars, jumping boards and running path etc. \n"
                "If you are looking to join a gymnastics club, please see gymnastics.",
                style: cusBodyStyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
