import 'dart:convert';

class ProfileViewModel {
  bool isLoading = false;
  String? error;

  String? name = "Steven Nikko V. Asuncion";
  String? title = "Software Developer";
  String? email = "asuncionsteven@gmail.com";
  String? location = "Philippines, PH";
  String? profileImage = "assets/images/steven_profile_pic.jpeg";
  String? githubUrl = "https://github.com/snvasuncion";
  String? linkedinUrl =
      "https://www.linkedin.com/in/steven-nikko-villanueva-asuncion/";

  List<String>? technicalSkills = [
    "Flutter/Dart",
    "Java",
    "React Native",
    "PHP",
    "Kotlin",
    "Google Maps API",
    "Firebase Integration",
    "REST API Integration",
  ];
  List<String>? frameworks = [
    "Flutter",
    "React",
    "React Native",
    "Next.js",
  ];
  List<String>? tools = [
    "VsCode",
    "Git",
    "Android Studio",
    "Jira",
    "Postman",
    "Figma",
    "Slack",
    "Trello",
    "GitHub Actions",
    "Agile/Scrum",
  ];

  List<Map<String, String>>? education = [
    {
      "degree": "Bachelor of Computer Science",
      "institution": "Asia Pacific College",
      "year": "2011-2015",
      "location": "Philippines, PH"
    },
  ];
  List<Map<String, dynamic>>? experience = [
    {
      "title": "Mobile Application Developer",
      "company": "Accenture",
      "period": "Aug 2021 – March 2024",
      "location": "Philippines, PH",
      "responsibilities": [
        "Delivered end-to-end feature development across 3 production mobile applications",
        "Drove cross-functional collaboration within Agile teams to meet client milestones",
        "Translated complex client requirements into scalable, maintainable technical solutions",
        "Utilized Git-based version control workflows to ensure smooth downstream code integration and team collaboration",
      ]
    },
    {
      "title": "Android Developer",
      "company": "Orizon Solutions Inc.",
      "period": "Sept 2017 – May 2019",
      "location": "Philippines, PH",
      "responsibilities": [
        "Engineered a full school management system from the ground up using Cordova & AngularJS",
        "Navigated the complete development lifecycle for assigned features, from initial requirements through successful implementation",
        "Diagnosed and resolved production-critical issues while consistently delivering high-priority user stories",
      ]
    },
    {
      "title": "Frontend Web Developer (Contract)",
      "company": "Tectus",
      "period": "Nov 2024 – Dec 2024",
      "location": "Philippines, PH",
      "responsibilities": [
        "Enhanced and stabilized web application quality by diagnosing and resolving defects using React.js",
        "Partnered with QA engineers to triage, prioritize, and resolve issues through Jira-based workflows",
        "Operated within sprint-based Agile cycles, consistently delivering on schedule",
      ]
    }
  ];

  Future<void> fetchProfileData() async {
  }

  String get safeName => name ?? "Loading...";
  String get safeTitle => title ?? "Software Developer";
  String get safeEmail => email ?? "Loading...";
  String get safeLocation => location ?? "Loading...";
  String get safeProfileImage =>
      profileImage ?? "assets/images/placeholder.jpg";
  String get safeGithubUrl => githubUrl ?? "https://github.com";
  String get safeLinkedinUrl => linkedinUrl ?? "https://linkedin.com";

  List<String> get safeTechnicalSkills => technicalSkills ?? [];
  List<String> get safeFrameworks => frameworks ?? [];
  List<String> get safeTools => tools ?? [];

  List<Map<String, String>> get safeEducation => education ?? [];
  List<Map<String, dynamic>> get safeExperience => experience ?? [];

  String getFullName() => safeName;
  String getJobTitle() => safeTitle;
  String getProfileImage() => safeProfileImage;

  String getFormattedExperience(Map<String, dynamic> exp) {
    final title = exp["title"] ?? "Unknown Position";
    final company = exp["company"] ?? "Unknown Company";
    final period = exp["period"] ?? "";
    final location = exp["location"] ?? "";

    return "$title at $company\n$period | $location";
  }

  List<String> getAllSkills() {
    return [...safeTechnicalSkills, ...safeFrameworks, ...safeTools];
  }

  Map<String, List<String>> getSkillsByCategory() {
    return {
      "Technical": safeTechnicalSkills,
      "Frameworks": safeFrameworks,
      "Tools": safeTools,
    };
  }

  Map<String, String> getLatestEducation() {
    return safeEducation.isNotEmpty ? safeEducation.first : {};
  }

  Map<String, dynamic> getLatestExperience() {
    return safeExperience.isNotEmpty ? safeExperience.first : {};
  }
}
