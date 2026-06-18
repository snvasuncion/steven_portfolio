import 'package:flutter/material.dart';
import '../data/data_provider.dart';

class Skill {
  final String name;
  final IconData icon;
  final String level;

  Skill({required this.name, required this.icon, required this.level});
}

/// Reads about/profile data from [DataProvider] (single source of truth).
class AboutViewModel {
  final DataProvider _data = DataProvider();

  final List<Skill> skills = [
    Skill(name: 'Flutter', icon: Icons.flutter_dash, level: 'Expert'),
    Skill(name: 'Dart', icon: Icons.code, level: 'Expert'),
    Skill(name: 'Java', icon: Icons.language, level: 'Advanced'),
    Skill(name: 'Kotlin', icon: Icons.developer_mode, level: 'Advanced'),
    Skill(name: 'React Native', icon: Icons.phone_android, level: 'Advanced'),
    Skill(name: 'Firebase', icon: Icons.cloud_queue, level: 'Advanced'),
    Skill(name: 'Git', icon: Icons.terminal, level: 'Advanced'),
    Skill(name: 'Bloc/Provider', icon: Icons.layers, level: 'Advanced'),
    Skill(name: 'REST APIs', icon: Icons.api, level: 'Intermediate'),
    Skill(name: 'React', icon: Icons.web, level: 'Intermediate'),
    Skill(name: 'Next.js', icon: Icons.desktop_windows, level: 'Intermediate'),
    Skill(name: 'TypeScript', icon: Icons.javascript, level: 'Intermediate'),
    Skill(name: 'CI/CD', icon: Icons.build, level: 'Intermediate'),
    Skill(name: 'DeepSeek', icon: Icons.auto_awesome, level: 'Advanced'),
    Skill(name: 'Claude', icon: Icons.psychology, level: 'Advanced'),
    Skill(name: 'OpenCode', icon: Icons.smart_toy, level: 'Advanced'),
    Skill(name: 'Android', icon: Icons.android, level: 'Advanced'),
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
