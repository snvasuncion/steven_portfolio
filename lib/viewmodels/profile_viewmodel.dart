import '../data/data_provider.dart';

/// Reads profile data from [DataProvider] (single source of truth).
class ProfileViewModel {
  final DataProvider _data = DataProvider();

  bool isLoading = false;
  String? error;

  // ---------------------------------------------------------------------------
  // Profile basics
  // ---------------------------------------------------------------------------

  String getFullName() => _data.name;
  String getJobTitle() => _data.title;
  String get safeEmail => _data.email;
  String get safeLocation => _data.location;
  String getProfileImage() => _data.profileImage;
  String get safeGithubUrl => _data.githubUrl;
  String get safeLinkedinUrl => _data.linkedinUrl;

  // ---------------------------------------------------------------------------
  // Experience
  // ---------------------------------------------------------------------------

  List<Map<String, dynamic>> get safeExperience => _data.experience;

  // ---------------------------------------------------------------------------
  // Education
  // ---------------------------------------------------------------------------

  List<Map<String, String>> get safeEducation => _data.education;

  // ---------------------------------------------------------------------------
  // Skills
  // ---------------------------------------------------------------------------

  List<String> get safeTechnicalSkills => _data.technicalSkills;
  List<String> get safeFrameworks => _data.frameworks;
  List<String> get safeTools => _data.tools;

  List<String> getAllSkills() {
    return [
      ..._data.technicalSkills,
      ..._data.frameworks,
      ..._data.tools,
    ];
  }

  Map<String, List<String>> getSkillsByCategory() {
    return {
      "Technical": _data.technicalSkills,
      "Frameworks": _data.frameworks,
      "Tools": _data.tools,
    };
  }

  Map<String, List<String>> get categorizedSkills =>
      _data.categorizedSkills;

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, String> getLatestEducation() {
    final edu = _data.education;
    return edu.isNotEmpty ? edu.first : {};
  }

  Map<String, dynamic> getLatestExperience() {
    final exp = _data.experience;
    return exp.isNotEmpty ? exp.first : {};
  }

  String getFormattedExperience(Map<String, dynamic> exp) {
    final title = exp["title"] ?? "Unknown Position";
    final company = exp["company"] ?? "Unknown Company";
    final period = exp["period"] ?? "";
    final location = exp["location"] ?? "";
    return "$title at $company\n$period | $location";
  }

  /// Kept for API compatibility — data now loads synchronously from DataProvider.
  Future<void> fetchProfileData() async {
    await _data.getProfileData();
  }
}
