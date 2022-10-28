import 'package:theme_detector/theme_detector.dart';
import 'package:test/test.dart';

// TODO: update tests
void main() {
  group('A group of tests', () {
    final awesome = ThemeDetecor();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.gtkThemeName, isException);
    });
  });
}
