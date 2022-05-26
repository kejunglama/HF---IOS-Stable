import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/components/custom_suffix_icon.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:healthfix/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController = TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(screenPadding)),
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(15)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(15)),
            buildConfirmPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            DefaultButton(
              text: "Sign Up",
              press: signUpButtonCallback,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      controller: confirmPasswordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Re-enter your password",
        // labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (confirmPasswordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (confirmPasswordFieldController.text != passwordFieldController.text) {
          return kMatchPassError;
        } else if (confirmPasswordFieldController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Enter your email",
        // labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyan, width: 0.1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: "Enter your password",
        // labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (passwordFieldController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signUpButtonCallback() async {
    if (_formKey.currentState.validate()) {
      // goto complete profile page
      final AuthentificationService authService = AuthentificationService();
      bool signUpStatus = false;
      String snackbarMessage;
      try {
        final signUpFuture = authService.signUp(
          email: emailFieldController.text,
          password: passwordFieldController.text,
        );
        signUpFuture.then((value) => signUpStatus = value);
        signUpStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              signUpFuture,
              message: Text("Creating new account"),
            );
          },
        );
        if (signUpStatus == true) {
          snackbarMessage = "Registered successfully, Please verify your email id";
        } else {
          throw FirebaseSignUpAuthUnknownReasonFailureException();
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
        if (signUpStatus == true) {
          Navigator.pop(context);
        }
      }
    }
  }
}
