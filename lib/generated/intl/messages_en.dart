// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(role) => "Let\'s Start with\nSign Up as ${role}";

  static String m1(role) => "Let\'s Start with\nSign in as ${role}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "chatDescription": MessageLookupByLibrary.simpleMessage(
      "Once you access the profile of doctor you selected, you can communicate with him and send any message.",
    ),
    "chooseDateTime": MessageLookupByLibrary.simpleMessage(
      "Choose date and time",
    ),
    "chooseDoctor": MessageLookupByLibrary.simpleMessage("Choose your doctor"),
    "chooseRole": MessageLookupByLibrary.simpleMessage(
      "Are you a Patient or a Doctor?",
    ),
    "communicateWithDoctor": MessageLookupByLibrary.simpleMessage(
      "Communicate with your doctor",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "continuee": MessageLookupByLibrary.simpleMessage("Continue"),
    "dateTimeDescription": MessageLookupByLibrary.simpleMessage(
      "The application can help you choose the appropriate date and time for you and the selected doctor.",
    ),
    "doctorDescription": MessageLookupByLibrary.simpleMessage(
      "Application provides you with a lot of experienced doctors...",
    ),
    "dontHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "emailHint": MessageLookupByLibrary.simpleMessage("Email"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "forgetPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your email for verification. We will send a 6-digit code.",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot password?"),
    "getStarted": MessageLookupByLibrary.simpleMessage(
      "Let\'s Get Started\nSelect Your Role",
    ),
    "imDoctor": MessageLookupByLibrary.simpleMessage("I\'m a Doctor"),
    "imPatient": MessageLookupByLibrary.simpleMessage("I\'m a Patient"),
    "invalidRole": MessageLookupByLibrary.simpleMessage("Invalid role"),
    "login": MessageLookupByLibrary.simpleMessage("Login"),
    "loginFailed": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password",
    ),
    "nameHint": MessageLookupByLibrary.simpleMessage("Name"),
    "next": MessageLookupByLibrary.simpleMessage("Next"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordHint": MessageLookupByLibrary.simpleMessage("Password"),
    "phoneHint": MessageLookupByLibrary.simpleMessage("Phone Number"),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter your email",
    ),
    "pleaseEnterName": MessageLookupByLibrary.simpleMessage(
      "Please enter your name",
    ),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "pleaseEnterPhone": MessageLookupByLibrary.simpleMessage(
      "Please enter your phone number",
    ),
    "registerAs": m0,
    "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
    "resetPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "Enter the code sent to your email and set a new password.",
    ),
    "roleNotProvided": MessageLookupByLibrary.simpleMessage(
      "Role not provided. Please go back and select a role.",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "signInAs": m1,
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "skip": MessageLookupByLibrary.simpleMessage("Skip"),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "userRegistrationFailed": MessageLookupByLibrary.simpleMessage(
      "User registration failed.",
    ),
    "userRegistrationSuccess": MessageLookupByLibrary.simpleMessage(
      "User registered successfully!",
    ),
  };
}
