import 'package:flutter/material.dart';

class Skill {
  final String name;
  final IconData icon;
  final String level;

  Skill({required this.name, required this.icon, required this.level});
}

class AboutViewModel {
  final List<Skill> skills = [
    Skill(name: 'Flutter', icon: Icons.flutter_dash, level: 'Expert'),
    Skill(name: 'Dart', icon: Icons.code, level: 'Expert'),
    Skill(name: 'Firebase', icon: Icons.cloud_queue, level: 'Advanced'),
    Skill(name: 'Git', icon: Icons.terminal, level: 'Advanced'),
    Skill(name: 'Bloc/Provider', icon: Icons.layers, level: 'Advanced'),
    Skill(name: 'REST APIs', icon: Icons.api, level: 'Expert'),
    Skill(name: 'React', icon: Icons.web, level: 'Intermediate'),
    Skill(name: 'Next.js', icon: Icons.desktop_windows, level: 'Intermediate'),
    Skill(name: 'TypeScript', icon: Icons.javascript, level: 'Intermediate'),
    Skill(name: 'CI/CD', icon: Icons.build, level: 'Intermediate'),
  ];

  String? intro =
      "Software Developer with 8 years of professional experience building and shipping mobile and web applications across enterprise and startup environments. Specializes in Flutter, Dart, and modern frontend frameworks, delivering production-ready solutions consistently on schedule. Experienced in cross-functional Agile teams at both enterprise and startup scale — translating complex business requirements into clean, maintainable code.";
  List<String>? whatIDo = [
    "Mobile Development (Flutter, React Native)",
    "Web Development (React, Next.js, TypeScript)",
    "State Management (Bloc, MVVM, Provider)",
    "Version Control (Git, GitHub)",
    "API Integration (RESTful APIs)",
    "CI/CD (GitHub Actions)",
    "UI/UX with clean, responsive design",
    "Agile Methodologies (Scrum, Jira)",
  ];
  List<String>? highlights = [
    "5+ Years Delivering Production Mobile Applications",
    "3+ Years Flutter & Dart — Shipped to Real Users",
    "Cross-Platform Expert: Flutter & React Native",
    "Full-Stack Capable: Mobile, Web & Backend Integration",
    "Clean Architecture & Code Quality Practitioner",
    "Agile Contributor Across Enterprise & Startup Environments",
    "Consistent On-Time Delivery Across All Roles",
    "User-First Mindset Reflected Across Every Shipped Product",
  ];
  String? funFact =
      "I'm an avid mobile gamer and figure collector - two hobbies that keep my appreciation for design and detail sharp.";

  bool isLoading = false;
  String? error;

  Future<void> fetchAboutData() async {}

  String get safeIntro => intro ?? "Loading...";
  List<String> get safeWhatIDo => whatIDo ?? [];
  List<String> get safeHighlights => highlights ?? [];
  String get safeFunFact => funFact ?? "Loading...";

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
