class ProfileViewModel {
  // Personal Information
  final String name = 'Steven Nikko V. Asuncion';
  final String title = 'Application Developer';
  final String email = 'asuncionsteven@gmail.com';
  final String location = 'Philippines, PH';
  final String profileImage = 'assets/images/steven_profile_pic.jpeg';
  // Social Links
  final String githubUrl = 'https://github.com/steveasuncion';
  final String linkedinUrl = 'https://linkedin.com/in/steveasuncion';
  // Add more social links as needed

  // Skills
  List<String> get technicalSkills => [
        'Flutter/Dart',
        'Java',
        'React Native',
        'PHP',
        'Kotlin',
        // Add more skills
      ];

  List<String> get frameworks => [
        'Flutter',
        'React',
        // Add more frameworks
      ];

  List<String> get tools => [
        'VsCode',
        'Git',
        'Firebase',
        'Android Studio',
        'Jira',
        'Postman',
        'Figma',
        'Slack',
        'Trello',
        // Add more tools
      ];

  // Education
  List<Map<String, String>> get education => [
        {
          'degree': 'Bachelor of Computer Science',
          'institution': 'Asia Pacific College',
          'year': '2011-2015',
          'location': 'Philippines, PH'
        },
        // Add more education
      ];

  // Experience
  List<Map<String, dynamic>> get experience => [
        {
          'title': 'Application Developer',
          'company': 'Accenture',
          'period': 'August 2021 - 2023',
          'location': 'Philippines, PH',
          'responsibilities': [
            'Developed and maintained mobile applications using Flutter and Kotlin',
            'Collaborated with cross-functional teams to deliver high-quality software',
            'Implemented responsive design patterns and best practices that satisfied client requirements',
            'Deliver deliverables on time and with quality',
          ]
        },
        {
          'title': 'Mobile Developer',
          'company': 'Orizon Solutions Incorporated',
          'period': 'September 2019 - May 2020',
          'location': 'Philippines, PH',
          'responsibilities': [
            '',
            'Managed project timelines and client communications effectively',
            'Ensured applications were optimized for performance and user experience',
          ]
        }
        // Add more experience
      ];

  // Methods to get specific information
  String getFullName() => name;
  String getJobTitle() => title;
  String getEmail() => email;
  String getLocation() => location;
  String getProfileImage() => profileImage;

  // Method to get formatted experience details
  String getFormattedExperience(Map<String, dynamic> exp) {
    return '${exp['title']} at ${exp['company']}\n'
        '${exp['period']} | ${exp['location']}';
  }

  // Method to get all skills combined
  List<String> getAllSkills() {
    return [...technicalSkills, ...frameworks, ...tools];
  }

  // Method to get skills by category
  Map<String, List<String>> getSkillsByCategory() {
    return {
      'Technical': technicalSkills,
      'Frameworks': frameworks,
      'Tools': tools,
    };
  }

  // Method to get latest education
  Map<String, String> getLatestEducation() {
    return education.first;
  }

  // Method to get latest experience
  Map<String, dynamic> getLatestExperience() {
    return experience.first;
  }
}
