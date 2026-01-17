class ContactViewModel {
  final String email = 'asuncionsteven@gmail.com';
  final String linkedinUrl = 'https://www.linkedin.com/in/steven-nikko-villanueva-asuncion/';
  final String githubUrl = 'https://github.com/snvasuncion';

  String getEmail() => email;
  String getLinkedinUrl() => linkedinUrl;
  String getGithubUrl() => githubUrl;

  Future<void> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {}
}
