import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileViewModel {
  final String profileId = "1";
  final String apiUrl =
      "https://69790a31cd4fe130e3db0374.mockapi.io/portfolio/v1/profile";

  String? name;
  String? title;
  String? email;
  String? location;
  String? profileImage;
  String? githubUrl;
  String? linkedinUrl;

  List<String>? technicalSkills;
  List<String>? frameworks;
  List<String>? tools;

  List<Map<String, String>>? education;
  List<Map<String, dynamic>>? experience;

  bool isLoading = false;
  String? error;

  Future<void> fetchProfileData() async {
    try {
      isLoading = true;
      error = null;

      final response = await http.get(Uri.parse('$apiUrl/$profileId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch profile data: ${response.statusCode}');
      }

      Map<String, dynamic> profileData = jsonDecode(response.body);

      name = profileData['name'];
      title = profileData['title'];
      email = profileData['email'];
      location = profileData['location'];
      profileImage = profileData['profileImage'];
      githubUrl = profileData['githubUrl'];
      linkedinUrl = profileData['linkedinUrl'];

      technicalSkills = _decodeStringArray(profileData['technicalSkills']);
      frameworks = _decodeStringArray(profileData['frameworks']);
      tools = _decodeStringArray(profileData['tools']);

      if (profileData['education'] != null &&
          profileData['education'].isNotEmpty) {
        final eduList = List<Map<String, dynamic>>.from(
            jsonDecode(profileData['education']));
        education =
            eduList.map((edu) => Map<String, String>.from(edu)).toList();
      } else {
        education = [];
      }

      if (profileData['experience'] != null &&
          profileData['experience'].isNotEmpty) {
        experience = List<Map<String, dynamic>>.from(
            jsonDecode(profileData['experience']));
      } else {
        experience = [];
      }
    } catch (e) {
      error = 'Error loading profile data: $e';

      _setDefaultValues();
    } finally {
      isLoading = false;
    }
  }

  List<String> _decodeStringArray(dynamic jsonString) {
    if (jsonString == null || jsonString.toString().isEmpty) {
      return [];
    }
    try {
      return List<String>.from(jsonDecode(jsonString));
    } catch (e) {
      return [];
    }
  }

  void _setDefaultValues() {
    name = "Steven Nikko V. Asuncion";
    title = "Software Developer";
    email = "asuncionsteven@gmail.com";
    location = "Philippines, PH";
    profileImage = "assets/images/steven_profile_pic.jpeg";
    githubUrl = "https://github.com/snvasuncion";
    linkedinUrl =
        "https://www.linkedin.com/in/steven-nikko-villanueva-asuncion/";

    technicalSkills = [
      "Flutter/Dart",
      "Java",
      "React Native",
      "PHP",
      "Kotlin",
      "Google Maps API",
      "Firebase Integration",
      "REST API Integration",
    ];

    frameworks = [
      "Flutter",
      "React",
      "React Native",
      "Next.js",
    ];

    tools = [
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

    education = [
      {
        "degree": "Bachelor of Computer Science",
        "institution": "Asia Pacific College",
        "year": "2011-2015",
        "location": "Philippines, PH"
      },
    ];

    experience = [
      {
        "title": "Mobile Application Developer",
        "company": "Accenture",
        "period": "Aug 2021 – March 2024",
        "location": "Philippines, PH",
        "responsibilities": [
          "Developed features and fixed bugs for 3 mobile applications",
          "Collaborated with cross-functional Agile teams",
          "Implemented client requirements into technical solutions",
          "Used Git for version control and team collaboration",
        ]
      },
      {
        "title": "Android Developer",
        "company": "Orizon Solutions Inc.",
        "period": "Sept 2017 – May 2019",
        "location": "Philippines, PH",
        "responsibilities": [
          "Built school management system with Cordova & AngularJS",
          "Managed full development lifecycle for features",
          "Resolved critical issues and implemented user stories",
        ]
      },
      {
        "title": "Frontend Web Developer (Contract)",
        "company": "Tectus",
        "period": "Nov 2024 – Dec 2024",
        "location": "Philippines, PH",
        "responsibilities": [
          "Fixed bugs and maintained website functionality using React.js",
          "Worked with QA team using Jira ticketing system",
          "Collaborated in Agile development environment",
        ]
      }
    ];
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
