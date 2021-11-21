import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Util {
  static String CreateId() {
    var _random = Random.secure();
    var random = List<int>.generate(32, (i) => _random.nextInt(256));
    var checker = base64Url.encode(random);

    checker =
        checker.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');

    var base64ToSha256 = utf8.encode(checker);
    return base64Url.encode(base64ToSha256);
  }

  static MaterialColor GetColorStatus(String satatus) {
    switch (satatus) {
      case "AGENDADA":
        return Colors.blue;

      case "REALIZADA":
        return Colors.green;
    }
    return Colors.red;
  }
}
