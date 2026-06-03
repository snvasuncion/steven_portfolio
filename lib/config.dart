/// Build-time configuration loaded via `--dart-define`.
///
/// Usage (replace `YOUR_PASSWORD` with your actual password):
/// ```sh
/// flutter run --dart-define=ADMIN_PASSWORD=YOUR_PASSWORD
/// flutter build web --dart-define=ADMIN_PASSWORD=YOUR_PASSWORD
/// ```
///
/// If no password is provided via --dart-define, the default fallback is used
/// (which should be changed for production).
class AppConfig {
  AppConfig._();

  /// The password required to access the admin moderation panel.
  static String get adminPassword =>
      const String.fromEnvironment('ADMIN_PASSWORD',
          defaultValue: 'snv@admin2026');
}
