// ignore_for_file: must_be_immutable

import 'package:healthfix/exceptions/firebaseauth/messeged_firebaseauth_exception.dart';

class FirebaseCredentialActionAuthException
    extends MessagedFirebaseAuthException {
  FirebaseCredentialActionAuthException(
      {final String message =
          "Instance of FirebasePasswordActionAuthException"})
      : super(message);
}

class FirebaseCredentialActionAuthUserNotFoundException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUserNotFoundException(
      {final String message = "No such user exist"})
      : super(message: message);
}

class FirebaseCredentialActionAuthWeakPasswordException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthWeakPasswordException(
      {final String message = "Password is weak, try something better"})
      : super(message: message);
}

class FirebaseCredentialActionAuthRequiresRecentLoginException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthRequiresRecentLoginException(
      {final String message = "This action requires re-Login"})
      : super(message: message);
}

class FirebaseCredentialActionAuthUnknownReasonFailureException
    extends FirebaseCredentialActionAuthException {
  FirebaseCredentialActionAuthUnknownReasonFailureException(
      {final String message =
          "The action can't be performed due to unknown reason"})
      : super(message: message);
}
