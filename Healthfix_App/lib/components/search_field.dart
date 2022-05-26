import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

// Cleaned
class SearchField extends StatelessWidget {
  final Function onSubmit;
  final String searchQuery;

  const SearchField({
    Key key,
    this.onSubmit,
    this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 0.3, color: Colors.grey),
      ),
      child: Container(
        height: getProportionateScreenHeight(40),
        child: TextFormField(
          initialValue: searchQuery,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          style: cusPdctCatNameStyle,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
            hintText: "Search Products, Brands, Vendors",
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Colors.cyan,
              size: getProportionateScreenHeight(25),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          ),
          // onSubmitted: onSubmit,
          onFieldSubmitted: onSubmit,
        ),
      ),
    );
  }
}
