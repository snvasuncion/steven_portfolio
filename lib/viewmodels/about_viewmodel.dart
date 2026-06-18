import 'package:flutter/material.dart';
import '../data/data_provider.dart';

class Skill {
  final String name;
  final IconData icon;

  Skill({required this.name, required this.icon});
}

/// Reads about/profile data from [DataProvider] (single source of truth).
class AboutViewModel {
  final DataProvider _data = DataProvider();

  final List<Skill> skills = [
    Skill(name: 'Flutter', icon: Icons.flutter_dash),
    Skill(name: 'Dart', icon: Icons.code),
    Skill(name: 'Java', icon: Icons.language),
    Skill(name: 'Kotlin', icon: Icons.developer_mode),
    Skill(name: 'React Native', icon: Icons.phone_android),
    Skill(name: 'Firebase', icon: Icons.cloud_queue),
    Skill(name: 'Git', icon: Icons.terminal),
    Skill(name: 'Bloc/Provider', icon: Icons.layers),
    Skill(name: 'REST APIs', icon: Icons.api),
    Skill(name: 'React', icon: Icons.web),
    Skill(name: 'Next.js', icon: Icons.desktop_windows),
    Skill(name: 'TypeScript', icon: Icons.javascript),
    Skill(name: 'CI/CD', icon: Icons.build),
    Skill(name: 'DeepSeek', icon: Icons.auto_awesome),
    Skill(name: 'Claude', icon: Icons.psychology),
    Skill(name: 'OpenCode', icon: Icons.smart_toy),
    Skill(name: 'Android', icon: Icons.android),
  ];

  bool isLoading = false;
  String? error;

  // ---------------------------------------------------------------------------
  // Text content — reads from DataProvider
  // ---------------------------------------------------------------------------

  /// The "About Me" intro paragraph (used by [safeIntro]).
  String get intro => _data.intro;

  /// Items in the "What I Specialized In" list.
  List<String> get whatIDo => _data.whatIDo;

  /// Highlight chips displayed in the "Professional Highlights" section.
  List<String> get highlights => _data.highlights;

  /// Fun fact displayed at the bottom of the About section.
  String get funFact => _data.funFact;

  // ---------------------------------------------------------------------------
  // Backwards-compatible safe accessors
  // ---------------------------------------------------------------------------

  String get safeIntro => intro.isNotEmpty ? intro : "Loading...";
  List<String> get safeWhatIDo => whatIDo;
  List<String> get safeHighlights => highlights;
  String get safeFunFact => funFact.isNotEmpty ? funFact : "Loading...";

  /// Kept for API compatibility — data now loads synchronously from DataProvider.
  Future<void> fetchAboutData() async {
    await _data.getProfileData();
  }

  Map<String, dynamic> toJson() {
    return {
      'intro': intro,
      'whatIDo': whatIDo,
      'highlights': highlights,
      'funFact': funFact,
      'isLoading': isLoading,
      'error': error,
    };
  }
}
