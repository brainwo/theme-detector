import 'dart:io';

const _gtkThemeQuery = 'gtk-theme-name';
const _gtkIconThemeQuery = 'gtk-icon-theme-name';
const _gsettingsThemeQuery = 'gtk-theme';
const _gsettingsIconThemeQuery = 'icon-theme';

/// Returns OS specific theme data
class ThemeDetecor {
  // TODO: better cache the file instead of read from the same file over and over
  Future<String?> _readGtkThemeName(File file, String resource) async {
    return (await file.readAsLines())
        .firstWhere((element) => element.startsWith(resource))
        .replaceAll(' ', '')
        .substring(resource.length + 1);
  }

  Future<String?> _readGsetting(String key) async {
    try {
      var themeName = (await Process.run(
        'gsettings',
        ["get", "org.gnome.desktop.interface", key],
      ))
          .stdout
          .toString()
          .trim();
      return themeName;
    } catch (_) {
      return null;
    }
  }

  /// (Only for Linux) get GTK theme name
  /// On different OS, it will throw an error `Exception('Not implemented')`
  ///
  /// Examples:
  /// ```dart
  /// import 'package:theme_detector/theme_detector.dart';
  /// void main() {
  ///   var themeDetector = ThemeDetector();
  ///   themeDetecor.gtkThemeName.then(
  ///     (themeName) {
  ///       print(themeName);
  ///     },
  ///   );
  /// }
  /// ```
  Future<String?> get gtkThemeName async {
    if (Platform.operatingSystem == "linux") {
      var xdgConfigHome = Platform.environment["XDG_CONFIG_HOME"];
      var localSetting = File("$xdgConfigHome/gtk-3.0/settings.inii");
      var gsetting = await _readGsetting(_gsettingsThemeQuery);
      var etcSetting = File("/etc/gtk-3.0/settings.ini");
      var usrSetting = File("/usr/share/gtk-3.0/settings.ini");

      if (await localSetting.exists()) {
        return _readGtkThemeName(localSetting, _gtkThemeQuery);
      } else if ((gsetting ?? '').isNotEmpty) {
        return gsetting!.substring(1, gsetting.length - 1);
      } else if (await etcSetting.exists()) {
        return _readGtkThemeName(etcSetting, _gtkThemeQuery);
      } else if (await usrSetting.exists()) {
        return _readGtkThemeName(usrSetting, _gtkThemeQuery);
      } else {
        return null;
      }
    } else {
      throw Exception('Not implemented');
    }
  }

  /// (Only for Linux) get GTK icon theme name
  /// On different OS, it will throw an error `Exception('Not implemented')`
  ///
  /// Examples:
  /// ```dart
  /// import 'package:theme_detector/theme_detector.dart';
  /// void main() {
  ///   var themeDetector = ThemeDetector();
  ///   themeDetecor.gtkIconThemeName.then(
  ///     (iconName) {
  ///       print(iconName);
  ///     },
  ///   );
  /// }
  /// ```
  Future<String?> get gtkIconThemeName async {
    if (Platform.operatingSystem == "linux") {
      var xdgConfigHome = Platform.environment["XDG_CONFIG_HOME"];
      var localSetting = File("$xdgConfigHome/gtk-3.0/settings.inii");
      var gsetting = await _readGsetting(_gsettingsIconThemeQuery);
      var etcSetting = File("/etc/gtk-3.0/settings.ini");
      var usrSetting = File("/usr/share/gtk-3.0/settings.ini");

      if (await localSetting.exists()) {
        return _readGtkThemeName(localSetting, _gtkIconThemeQuery);
      } else if ((gsetting ?? '').isNotEmpty) {
        return gsetting!.substring(1, gsetting.length - 1);
      } else if (await etcSetting.exists()) {
        return _readGtkThemeName(etcSetting, _gtkIconThemeQuery);
      } else if (await usrSetting.exists()) {
        return _readGtkThemeName(usrSetting, _gtkIconThemeQuery);
      } else {
        return null;
      }
    } else {
      throw Exception('Not implemented');
    }
  }

  // Return font name used by the operating system
  Future<String?> get platformFontName async {
    switch (Platform.operatingSystem) {
      case "linux":
      default:
        throw Exception('TODO');
    }
  }
}
