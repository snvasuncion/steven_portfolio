class ProfileViewModel {
  // Personal Information
  final String name = 'Steven Nikko V. Asuncion';
  final String title = 'Software Developer';
  final String email = 'asuncionsteven@gmail.com';
  final String location = 'Philippines, PH';
  final String profileImage = 'assets/images/steven_profile_pic.jpeg';
  // Social Links
  final String githubUrl = 'https://github.com/steveasuncion';
  final String linkedinUrl = 'https://linkedin.com/in/steveasuncion';

  // Skills
  List<String> get technicalSkills => [
        'Flutter/Dart',
        'Java',
        'React Native',
        'PHP',
        'Kotlin',
        'Google Maps API',
        'Firebase Integration',
        'REST API Integration',
      ];

  List<String> get frameworks => [
        'Flutter',
        'React',
        'React Native',
        'Next.js',
      ];

  List<String> get tools => [
        'VsCode',
        'Git',
        'Android Studio',
        'Jira',
        'Postman',
        'Figma',
        'Slack',
        'Trello',
        'GitHub Actions',
        'Agile/Scrum',
      ];

  // Education
  List<Map<String, String>> get education => [
        {
          'degree': 'Bachelor of Computer Science',
          'institution': 'Asia Pacific College',
          'year': '2011-2015',
          'location': 'Philippines, PH'
        },
      ];

  List<Map<String, dynamic>> get experience => [
        {
          'title': 'Mobile Application Developer',
          'company': 'Accenture',
          'period': 'Aug 2021 – March 2024',
          'location': 'Philippines, PH',
          'responsibilities': [
            'Developed features and fixed bugs for 3 mobile applications',
            'Collaborated with cross-functional Agile teams',
            'Implemented client requirements into technical solutions',
            'Used Git for version control and team collaboration',
          ]
        },
        {
          'title': 'Android Developer',
          'company': 'Orizon Solutions Inc.',
          'period': 'Sept 2017 – May 2019',
          'location': 'Philippines, PH',
          'responsibilities': [
            'Built school management system with Cordova & AngularJS',
            'Managed full development lifecycle for features',
            'Resolved critical issues and implemented user stories',
          ]
        },
        {
          'title': 'Frontend Web Developer (Contract)',
          'company': 'Tectus',
          'period': 'Nov 2024 – Dec 2024',
          'location': 'Philippines, PH',
          'responsibilities': [
            'Fixed bugs and maintained website functionality using React.js',
            'Worked with QA team using Jira ticketing system',
            'Collaborated in Agile development environment',
          ]
        }
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
