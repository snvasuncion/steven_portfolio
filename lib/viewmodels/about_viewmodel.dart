import 'dart:convert';
import 'package:http/http.dart' as http;

class AboutViewModel {
  final String profileId = "1";
  final String apiUrl =
      "https://69790a31cd4fe130e3db0374.mockapi.io/portfolio/v1/profile";

  String? intro;
  List<String>? whatIDo;
  List<String>? highlights;
  String? funFact;

  bool isLoading = false;
  String? error;

  Future<void> fetchAboutData() async {
    try {
      isLoading = true;
      error = null;

      final response = await http.get(Uri.parse('$apiUrl/$profileId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch about data: ${response.statusCode}');
      }

      Map<String, dynamic> profileData = jsonDecode(response.body);

      intro = profileData['intro'];
      funFact = profileData['funFact'];

      if (profileData['whatIDo'] != null && profileData['whatIDo'].isNotEmpty) {
        whatIDo = List<String>.from(jsonDecode(profileData['whatIDo']));
      } else {
        whatIDo = [];
      }

      if (profileData['highlights'] != null &&
          profileData['highlights'].isNotEmpty) {
        highlights = List<String>.from(jsonDecode(profileData['highlights']));
      } else {
        highlights = [];
      }
    } catch (e) {
      error = 'Error loading about data: $e';

      intro =
          "I'm a Software Developer with 8 years of experience in the industry. Proven expertise in delivering successful projects with strong skills in Git version control and Agile methodologies. Notable achievements include the successful implementation of new features and resolution of critical bugs across multiple projects. Committed to translating business needs into functional solutions, leveraging strong technical skills to enhance user experience and drive project success.";
      whatIDo = [
        "Mobile Development (Flutter, React Native)",
        "Web Development (React, Next.js, TypeScript)",
        "State Management (Bloc, MVVM, Provider)",
        "Version Control (Git, GitHub)",
        "API Integration (RESTful APIs)",
        "CI/CD (GitHub Actions)",
        "UI/UX with clean, responsive design",
        "Agile Methodologies (Scrum, Jira)",
      ];
      highlights = [
        "5+ Years of Professional Mobile Development Experience",
        "3+ Years Flutter & Dart Expertise with Production Apps",
        "Cross-Platform Development (Flutter & React Native)",
        "Expanding Skills into Full-Stack Development",
        "Strong Focus on Clean Architecture & Code Quality",
        "Experienced with Agile Methodologies & Team Collaboration",
        "Proven Ability to Solve Complex Technical Challenges",
        "Dedicated to Building High-Quality, User-Focused Applications",
      ];
      funFact =
          "I'm an avid mobile gamer and figure collector - two hobbies that keep my appreciation for design and detail sharp.";
    } finally {
      isLoading = false;
    }
  }

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
