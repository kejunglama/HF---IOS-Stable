import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:healthfix/components/custom_suffix_icon.dart';
import 'package:healthfix/components/default_button.dart';
import 'package:healthfix/components/no_account_text.dart';
import 'package:healthfix/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:healthfix/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';
import 'package:healthfix/services/authentification/authentification_service.dart';
import 'package:healthfix/size_config.dart';
import 'package:logger/logger.dart';

import '../../../constants.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();

  @override
  void dispose() {
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Send Verification Email",
            press: sendVerificationEmailButtonCallback,
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.26),
          NoAccountText(),
          // SizedBox(height: getProportionateScreenHeight(30)),
        ],
      ),
    );
  }

  TextFormField buildEmailFormField() {
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
        if (value.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      // autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> sendVerificationEmailButtonCallback() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final String emailInput = emailFieldController.text.trim();
      bool resultStatus;
      String snackbarMessage;
      try {
        final resultFuture = AuthentificationService().resetPasswordForEmail(emailInput);
        resultFuture.then((value) => resultStatus = value).catchError( (e) => snackbarMessage = e.toString());
        resultStatus = await showDialog(
          context: context,
          builder: (context) {
            return FutureProgressDialog(
              resultFuture,
              message: Text("Sending verification email"),
            );
          },
        );
        if (resultStatus == true) {
          snackbarMessage = "Password Reset Link sent to your email";
        }
        else {
          throw snackbarMessage ?? FirebaseCredentialActionAuthUnknownReasonFailureException(message: "Sorry, could not process your request now, try again later");
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        // print(e.code);
        // print(e.message);
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        print(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
  }
}
