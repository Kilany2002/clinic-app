// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Choose your doctor`
  String get chooseDoctor {
    return Intl.message(
      'Choose your doctor',
      name: 'chooseDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Choose date and time`
  String get chooseDateTime {
    return Intl.message(
      'Choose date and time',
      name: 'chooseDateTime',
      desc: '',
      args: [],
    );
  }

  /// `Communicate with your doctor`
  String get communicateWithDoctor {
    return Intl.message(
      'Communicate with your doctor',
      name: 'communicateWithDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Application provides you with a lot of experienced doctors...`
  String get doctorDescription {
    return Intl.message(
      'Application provides you with a lot of experienced doctors...',
      name: 'doctorDescription',
      desc: '',
      args: [],
    );
  }

  /// `The application can help you choose the appropriate date and time for you and the selected doctor.`
  String get dateTimeDescription {
    return Intl.message(
      'The application can help you choose the appropriate date and time for you and the selected doctor.',
      name: 'dateTimeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Once you access the profile of doctor you selected, you can communicate with him and send any message.`
  String get chatDescription {
    return Intl.message(
      'Once you access the profile of doctor you selected, you can communicate with him and send any message.',
      name: 'chatDescription',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Let's Get Started\nSelect Your Role`
  String get getStarted {
    return Intl.message(
      'Let\'s Get Started\nSelect Your Role',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Are you a Patient or a Doctor?`
  String get chooseRole {
    return Intl.message(
      'Are you a Patient or a Doctor?',
      name: 'chooseRole',
      desc: '',
      args: [],
    );
  }

  /// `I'm a Patient`
  String get imPatient {
    return Intl.message(
      'I\'m a Patient',
      name: 'imPatient',
      desc: '',
      args: [],
    );
  }

  /// `I'm a Doctor`
  String get imDoctor {
    return Intl.message('I\'m a Doctor', name: 'imDoctor', desc: '', args: []);
  }

  /// `Let's Start with\nSign in as {role}`
  String signInAs(Object role) {
    return Intl.message(
      'Let\'s Start with\nSign in as $role',
      name: 'signInAs',
      desc: '',
      args: [role],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Invalid role`
  String get invalidRole {
    return Intl.message(
      'Invalid role',
      name: 'invalidRole',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password`
  String get loginFailed {
    return Intl.message(
      'Invalid email or password',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email for verification. We will send a 6-digit code.`
  String get forgetPasswordDescription {
    return Intl.message(
      'Enter your email for verification. We will send a 6-digit code.',
      name: 'forgetPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Continue`
  String get continuee {
    return Intl.message('Continue', name: 'continuee', desc: '', args: []);
  }

  /// `Let's Start with\nSign Up as {role}`
  String registerAs(Object role) {
    return Intl.message(
      'Let\'s Start with\nSign Up as $role',
      name: 'registerAs',
      desc: '',
      args: [role],
    );
  }

  /// `Name`
  String get nameHint {
    return Intl.message('Name', name: 'nameHint', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneHint {
    return Intl.message('Phone Number', name: 'phoneHint', desc: '', args: []);
  }

  /// `Email`
  String get emailHint {
    return Intl.message('Email', name: 'emailHint', desc: '', args: []);
  }

  /// `Password`
  String get passwordHint {
    return Intl.message('Password', name: 'passwordHint', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Please enter your name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter your name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `User registration failed.`
  String get userRegistrationFailed {
    return Intl.message(
      'User registration failed.',
      name: 'userRegistrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `User registered successfully!`
  String get userRegistrationSuccess {
    return Intl.message(
      'User registered successfully!',
      name: 'userRegistrationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Role not provided. Please go back and select a role.`
  String get roleNotProvided {
    return Intl.message(
      'Role not provided. Please go back and select a role.',
      name: 'roleNotProvided',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter the code sent to your email and set a new password.`
  String get resetPasswordDescription {
    return Intl.message(
      'Enter the code sent to your email and set a new password.',
      name: 'resetPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
