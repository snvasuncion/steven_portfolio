class ContactViewModel {
  // Contact Information
  final String email = 'steven.asuncion.dev@gmail.com';
  final String linkedinUrl = 'https://linkedin.com/in/steveasuncion';
  final String githubUrl = 'https://github.com/steveasuncion';

  // Methods to get contact information
  String getEmail() => email;
  String getLinkedinUrl() => linkedinUrl;
  String getGithubUrl() => githubUrl;

  // Method to handle form submission
  Future<void> sendMessage({
    required String name,
    required String email,
    required String message,
  }) async {
    // Implement your email sending logic here
    // You could use a backend service, email API, or other solution
    // For now, this is a placeholder
  }
}
