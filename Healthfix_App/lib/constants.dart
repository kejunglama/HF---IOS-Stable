import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthfix/size_config.dart';
import 'package:intl/intl.dart';

const String appName = "Healthfix";

const kPrimaryColor = Color(0xFF01B2C6);
const kFitCalColor = Color(0xFF6e278e);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF01B2C6), Colors.cyan],
);
const kSecondaryColor = Colors.blue;
const kTextColor = Color(0xFF757575);
const kHeadingColor = Color(0xFF0d1f2d);

const kAnimationDuration = Duration(milliseconds: 200);

const double screenPadding = 10;

final headingStyle = TextStyle(
  fontSize: getProportionateScreenHeight(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

// Custom Font Styles
cusHeadingStyle(
        {double fontSize,
        Color color,
        bool hasShadow,
        FontWeight fontWeight,
        double lineheight,
        double letterSpacing}) =>
    GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize ?? getProportionateScreenHeight(20),
        fontWeight: fontWeight ?? FontWeight.w500,
        letterSpacing: letterSpacing ?? getProportionateScreenHeight(0.25),
        height: lineheight ?? null,
        shadows: <Shadow>[
          if (hasShadow ?? false)
            Shadow(
              // offset: Offset(10.0, 10.0),
              blurRadius: 100.0,
              color: Color.fromARGB(200, 0, 0, 0),
            ),
          if (hasShadow ?? false)
            Shadow(
              offset: Offset(1.0, 3.0),
              blurRadius: 40.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
        ],
      ),
    );

cusBodyStyle({double fontSize, FontWeight fontWeight, Color color, double letterSpacing}) => GoogleFonts.roboto(
      textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize ?? getProportionateScreenHeight(14),
        fontWeight: fontWeight ?? FontWeight.w300,
        letterSpacing: letterSpacing ?? (0.03125 * (fontSize ?? getProportionateScreenHeight(14))),
        height: 1.5,
      ),
    );

cusHeadingLinkStyle() => GoogleFonts.roboto(
      textStyle: TextStyle(
        color: kPrimaryColor,
        fontSize: (12),
        fontWeight: FontWeight.w300,
      ),
    );

cusCenterHeadingStyle([Color color, FontWeight fw, num fs]) => GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: fs ?? getProportionateScreenHeight(16),
        fontWeight: fw ?? FontWeight.w400,
        letterSpacing: 0.5,
      ),
    );

cusCenterHeadingAccentStyle() => GoogleFonts.poppins(
      textStyle: TextStyle(
        color: kSecondaryColor,
        fontSize: getProportionateScreenHeight(16),
      ),
    );

cusPdctCatNameStyle() => GoogleFonts.poppins(
      textStyle: TextStyle(
        letterSpacing: 0.25,
        color: kSecondaryColor,
        fontSize: 12,
        // fontSize: getProportionateScreenHeight(8),
        fontWeight: FontWeight.w400,
      ),
    );

cusPdctDisPriceStyle([double fs, Color color]) => GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color ?? Colors.black,
        // fontWeight: FontWeight.w600,
        fontSize: fs ?? getProportionateScreenHeight(12),
        letterSpacing: 0.5,
      ),
    );
cusPdctPageDisPriceStyle([double fs, Color color]) => GoogleFonts.poppins(
      textStyle: TextStyle(
        color: color ?? kPrimaryColor,
        fontWeight: FontWeight.w600,
        fontSize: fs ?? getProportionateScreenHeight(12),
        letterSpacing: -0.3,
      ),
    );

cusPdctOriPriceStyle([double fs]) => GoogleFonts.poppins(
      textStyle: TextStyle(
        color: kTextColor,
        decoration: TextDecoration.lineThrough,
        fontWeight: FontWeight.normal,
        fontSize: fs ?? getProportionateScreenHeight(10),
        // letterSpacing: 0.5,
      ),
    );

cusPdctNameStyle() => GoogleFonts.poppins(
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 12,
        letterSpacing: 0.25,
      ),
    );

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String FIELD_REQUIRED_MSG = "This field is required";

final otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenHeight(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

var currency = new NumberFormat.currency(locale: "en_US", symbol: "Rs. ", decimalDigits: 0);

DateTime now = new DateTime.now();

var cusDateTimeFormatter = new DateFormat('yyyy-MM-dd hh:mma');
var cusDateFormatter = new DateFormat('yyyy-MM-dd');
