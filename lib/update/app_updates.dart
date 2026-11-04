import 'update_checker.dart';
import 'update_installer.dart';

/// Everything the screens need to offer app updates, created once in
/// main.dart and passed down.
class AppUpdates {
  const AppUpdates({
    required this.checker,
    required this.installer,
    this.checkOnStartup = true,
  });

  final UpdateChecker checker;
  final UpdateInstaller installer;

  /// Whether to look for a new version when the home screen opens. The
  /// manual check on the home screen works either way.
  final bool checkOnStartup;
}
