import 'dart:convert';
import 'dart:math';

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
}
