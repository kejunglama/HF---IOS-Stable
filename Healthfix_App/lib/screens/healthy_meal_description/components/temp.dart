// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:healthfix/constants.dart';
import 'package:healthfix/size_config.dart';

class CusTabs extends StatefulWidget {
  List<Widget> tabsHeader = [];
  List<Widget> tabsBody = [];
  CusTabs({
    Key key,
    this.tabsHeader,
    this.tabsBody,
  }) : super(key: key);

  @override
  _CusTabsState createState() => _CusTabsState();
}

class _CusTabsState extends State<CusTabs> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController =
        TabController(length: widget.tabsHeader.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyList = [];
    bodyList.add(Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(8),
          vertical: getProportionateScreenHeight(16)),
      child: widget.tabsBody.first,
    ));
    widget.tabsBody.sublist(1).forEach((element) {
      bodyList.add(Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(8),
            vertical: getProportionateScreenHeight(16)),
        child: element,
      ));
    });
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabBar(
          controller: _tabController,
          // labelColor: kPrimaryColor,
          labelStyle: cusBodyStyle(getProportionateScreenHeight(16)),
          tabs: widget.tabsHeader,
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
        ),
        bodyList[_tabController.index],
      ],
    );
  }
}
