import 'package:theme_detector/theme_detector.dart';

void main() {
  var themeDetector = ThemeDetecor();

  themeDetector.gtkThemeName.then(
    (value) {
      print('$value');
    },
  );
}
