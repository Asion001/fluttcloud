// ignore_for_file: use_string_buffers

import 'dart:convert';

import 'package:fluttcloud_server/common_imports.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

RegExp alphaRegExp = RegExp(r'^[a-zA-Z]+$');

// String Extensions
extension StringExtension on String? {
  /// Returns true if given String is null or isEmpty
  bool get isEmptyOrNull =>
      this == null ||
      (this != null && this!.isEmpty) ||
      (this != null && this! == 'null');

  // Check null string, return given value if null
  String validate({String value = ''}) {
    if (isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }

  /// Capitalize given String
  String capitalizeFirstLetter() => (validate().isNotEmpty)
      ? (this!.substring(0, 1).toUpperCase() + this!.substring(1).toLowerCase())
      : validate();

  /// Return true if given String is Digit
  bool isDigit() {
    if (validate().isEmpty) {
      return false;
    }
    if (validate().length > 1) {
      for (final r in this!.runes) {
        if (r ^ 0x30 > 9) {
          return false;
        }
      }
      return true;
    } else {
      return this!.runes.first ^ 0x30 <= 9;
    }
  }

  bool get isInt => this!.isDigit();

  /// Check weather String is alpha or not
  bool isAlpha() => alphaRegExp.hasMatch(validate());

  bool isJson() {
    try {
      json.decode(validate());
    } catch (e) {
      return false;
    }
    return true;
  }

  /// for ex. add comma in price
  String formatNumberWithComma({String seperator = ','}) {
    return validate().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}$seperator',
    );
  }

  /// It reverses the String
  String get reverse {
    if (validate().isEmpty) {
      return '';
    }
    return toList().reversed.reduce((value, element) => value += element);
  }

  /// It return list of single character from String
  List<String> toList() {
    return validate().trim().split('');
  }

  /// Splits from a [pattern] and returns remaining String after that
  String splitAfter(Pattern pattern) {
    ArgumentError.checkNotNull(pattern, 'pattern');
    final matchIterator = pattern.allMatches(this!).iterator;

    if (matchIterator.moveNext()) {
      final match = matchIterator.current;
      final length = match.end - match.start;
      return validate().substring(match.start + length);
    }
    return '';
  }

  /// Splits from a [pattern] and returns String before that
  String splitBefore(Pattern pattern) {
    ArgumentError.checkNotNull(pattern, 'pattern');
    final matchIterator = pattern.allMatches(validate()).iterator;

    Match? match;
    while (matchIterator.moveNext()) {
      match = matchIterator.current;
    }

    if (match != null) {
      return validate().substring(0, match.start);
    }
    return '';
  }

  /// It matches the String and returns between [startPattern] and [endPattern]
  String splitBetween(Pattern startPattern, Pattern endPattern) {
    return splitAfter(startPattern).splitBefore(endPattern);
  }

  /// Return int value of given string
  int toInt({int defaultValue = 0}) {
    if (this == null) return defaultValue;

    if (isDigit()) {
      return int.parse(this!);
    } else {
      return defaultValue;
    }
  }

  /// Return double value of given string
  double toDouble({double defaultValue = 0.0}) {
    if (this == null) return defaultValue;

    try {
      return double.parse(this!);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Removes white space from given String
  String removeAllWhiteSpace() =>
      validate().replaceAll(RegExp(r'\s+\b|\b\s'), '');

  /// Returns only numbers from a string trim Whitespaces
  String getNumericOnly({bool aFirstWordOnly = false}) {
    var numericOnlyString = '';

    for (var i = 0; i < validate().length; i++) {
      if (this![i].isDigit()) {
        numericOnlyString += this![i];
      }
      if (aFirstWordOnly && numericOnlyString.isNotEmpty && this![i] == ' ') {
        break;
      }
    }

    return numericOnlyString;
  }

  /// Returns the given string n times
  String repeat(int n, {String separator = ''}) {
    if (n < 0) ArgumentError('n must be a positive value greater then 0');

    var repeatedString = '';

    for (var i = 0; i < n; i++) {
      if (i > 0) {
        repeatedString += separator;
      }
      repeatedString += validate();
    }

    return repeatedString;
  }

  /// Render a HTML String
  String get renderHtml {
    return this!
        .replaceAll('&ensp;', ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&emsp;', ' ')
        .replaceAll('<br>', '\n')
        .replaceAll('<br/>', '\n')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  /// Return average read time duration of given String in seconds
  double calculateReadTime({int wordsPerMinute = 200}) {
    final words = countWords();
    final number = words / wordsPerMinute;
    return number;
  }

  /// Return number of words ina given String
  int countWords() {
    final words = validate().trim().split(RegExp(r'(\s+)'));
    return words.length;
  }

  /// Generate slug of a given String
  String toSlug({String delimiter = '_'}) {
    final text = validate().trim().toLowerCase();
    return text.replaceAll(' ', delimiter);
  }

  /// returns searchable array for Firebase Database
  List<String> setSearchParam() {
    final word = validate();

    final caseSearchList = <String>[];
    var temp = '';

    for (var i = 0; i < word.length; i++) {
      temp = temp + word[i];
      caseSearchList.add(temp.toLowerCase());
    }

    return caseSearchList;
  }

  /// Returns true if given value is '1', else returns false
  bool getBoolInt() {
    if (this == '1') {
      return true;
    }
    return false;
  }

  String prefixText({required String value}) {
    return '$value$this';
  }

  ///  eg. Text("${VARIABLE_NAME} /-"); =>  Text("VARIABLE_NAME.suffixText("/-")");
  String suffixText({required String value}) {
    return '$this$value';
  }

  /// This function returns given string with each word capital
  String capitalizeEachWord() {
    if (validate().isEmpty) {
      return '';
    }

    final capitalizedWords = this!.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      final firstLetter = word[0].toUpperCase();
      final remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    });

    return capitalizedWords.join(' ');
  }

  bool toBool() => validate() == 'true';

  bool get asBool => this == 'true';
}

extension SessionExt on Session {
  Future<UserInfo?> getRequestUser() async {
    final auth = await authenticated;
    if (auth?.userId == null) throw const UnAuthorizedException();
    return Users.findUserByUserId(this, auth!.userId);
  }
}

extension UserInfoExt on UserInfo? {
  bool get isAdmin => this?.scopes.contains(Scope.admin) ?? false;
}

extension AuthenticationInfoExt on AuthenticationInfo? {
  bool get isAdmin => this?.scopes.contains(Scope.admin) ?? false;
}
