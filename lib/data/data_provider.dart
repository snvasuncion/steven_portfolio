import 'dart:async';

/// Singleton data provider — the single source of truth for all portfolio data.
///
/// Both [ProfileViewModel] and [AboutViewModel] read from this class
/// instead of maintaining their own hardcoded copies.
class DataProvider {
  static final DataProvider _instance = DataProvider._internal();
  factory DataProvider() => _instance;
  DataProvider._internal();

  Map<String, dynamic>? _cachedData;
  List<dynamic>? _cachedProjects;

  Map<String, dynamic>? get cachedData => _cachedData;
  List<dynamic>? get cachedProjects => _cachedProjects;

  // ---------------------------------------------------------------------------
  // Profile / About data
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> getProfileData() async {
    _cachedData = _defaultData();
    return _cachedData!;
  }

  /// Convenience accessors used by view models.
  String get name => _cachedData?['name'] as String? ?? '';
  String get title => _cachedData?['title'] as String? ?? '';
  String get email => _cachedData?['email'] as String? ?? '';
  String get location => _cachedData?['location'] as String? ?? '';
  String get profileImage => _cachedData?['profileImage'] as String? ?? '';
  String get githubUrl => _cachedData?['githubUrl'] as String? ?? '';
  String get linkedinUrl => _cachedData?['linkedinUrl'] as String? ?? '';
  String get intro => _cachedData?['intro'] as String? ?? '';
  String get funFact => _cachedData?['funFact'] as String? ?? '';
  List<String> get whatIDo =>
      List<String>.from(_cachedData?['whatIDo'] ?? []);
  List<String> get highlights =>
      List<String>.from(_cachedData?['highlights'] ?? []);
  List<String> get technicalSkills =>
      List<String>.from(_cachedData?['technicalSkills'] ?? []);
  List<String> get frameworks =>
      List<String>.from(_cachedData?['frameworks'] ?? []);
  List<String> get tools => List<String>.from(_cachedData?['tools'] ?? []);
  Map<String, List<String>> get categorizedSkills =>
      Map<String, List<String>>.from(
          (_cachedData?['categorizedSkills'] as Map?)?.map(
                (key, value) => MapEntry(key, List<String>.from(value)),
              ) ??
              {});
  List<Map<String, String>> get education =>
      List<Map<String, String>>.from(_cachedData?['education'] ?? []);
  List<Map<String, dynamic>> get experience =>
      List<Map<String, dynamic>>.from(_cachedData?['experience'] ?? []);

  // ---------------------------------------------------------------------------
  // Projects
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> getProjectsData() async {
    _cachedProjects = [
      {
        'id': '1',
        'title': "Custom Weather Map App",
        'description':
            "Simple weather forecasting application featuring user authentication, location-based weather search, and search history functionality. Built using MVVM architecture with comprehensive error handling for a seamless user experience. \n\nThis application was developed for a job assessment.",
        'githubUrl': "https://github.com/snvasuncion/WeatherApp",
        'technologies': ["React Native", "JavaScript", "REST API"],
      },
      {
        'id': '2',
        'title': "SNVWorks Portfolio",
        'description':
            "A responsive, cross-platform portfolio website built with Flutter for web. Features include:\n"
            "- Animated splash screen with staggered fade-scale transitions\n"
            "- Dark/Light theme toggle with custom color schemes\n"
            "- Scroll-triggered entrance animations for a dynamic browsing experience\n"
            "- Smooth slide+fade page transitions between sections\n"
            "- Password-protected admin panel for message moderation\n"
            "- Contact form with approval queue system\n"
            "- Custom animated toast notifications\n"
            "- Downloadable ATS-optimized resume (PDF)\n"
            "- PWA support with installable manifest and service worker\n"
            "- SEO optimization with Open Graph meta tags\n"
            "- Responsive design (mobile drawer + desktop navbar)\n"
            "- Built with assistance from GenAI tools (OpenCode/Claude) for rapid development, debugging, and architectural guidance.",
        'githubUrl': '',
        'technologies': ["Flutter", "Dart", "flutter_bloc", "Google Fonts", "flutter_svg", "Shimmer", "HTTP", "WASM", "CSS3"],
      }
    ];
    return _cachedProjects!;
  }

  // ---------------------------------------------------------------------------
  // Data
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _defaultData() {
    return {
      'name': 'Steven Nikko V. Asuncion',
      'title': 'Software Developer',
      'email': 'asuncionsteven@gmail.com',
      'location': 'Philippines, PH',
      'profileImage': 'assets/images/steven_profile_pic.jpeg',
      'githubUrl': 'https://github.com/snvasuncion',
      'linkedinUrl':
          'https://www.linkedin.com/in/steven-nikko-villanueva-asuncion/',
      'intro':
          "Dynamic Software Developer with over 5 years of experience in mobile and web application development. Proven track record of delivering successful projects, utilizing Agile methodologies to translate business needs into functional, high-quality solutions that enhance user experience. Highly adaptable and GenAI-fluent \u2014 leveraging tools like Claude, DeepSeek, OpenCode, and Gemini to accelerate development workflows, rapidly prototype new features, and maintain strict code quality.",
      'funFact':
          "I'm an avid mobile gamer and figure collector - two hobbies that keep my appreciation for design and detail sharp.",
      'whatIDo': [
        "Mobile Development (Flutter, React Native)",
        "Web Development (React, Next.js, TypeScript)",
        "State Management (Bloc, MVVM, Provider)",
        "Version Control (Git, GitHub)",
        "API Integration (RESTful APIs)",
        "CI/CD (GitHub Actions)",
        "UI/UX with clean, responsive design",
        "Agile Methodologies (Scrum, Jira)"
      ],
      'highlights': [
        "5+ Years of Professional Mobile Development Experience",
        "3+ Years Flutter & Dart Expertise with Production Apps",
        "Cross-Platform Development (Flutter & React Native)",
        "Expanding Skills into Full-Stack Development",
        "Strong Focus on Clean Architecture & Code Quality",
        "Experienced with Agile Methodologies & Team Collaboration",
        "Proven Ability to Solve Complex Technical Challenges",
        "Dedicated to Building High-Quality, User-Focused Applications"
      ],
      'technicalSkills': [
        "Java",
        "Dart",
        "React Native",
        "Kotlin",
        "React",
        "Next.js",
        "Android",
        "Flutter",
        "Firebase",
        "SQLite",
        "REST API Integration"
      ],
      'frameworks': ["Flutter", "React", "React Native", "Next.js"],
      'tools': [
        "Git",
        "SourceTree",
        "Android Studio",
        "VSCode",
        "WebStorm",
        "Antigravity",
        "Xcode",
        "DeepSeek",
        "Claude",
        "ChatGPT",
        "Gemini",
        "OpenCode",
        "Odysseus"
      ],
      'categorizedSkills': {
        'Programming Languages': [
          "Java",
          "Dart",
          "React Native",
          "Kotlin",
          "React",
          "Next.js"
        ],
        'Platforms & Cloud': [
          "Android",
          "Flutter",
          "Web",
          "Firebase",
          "SQLite"
        ],
        'AI & Engineering Tools': [
          "DeepSeek",
          "Claude",
          "ChatGPT",
          "Gemini",
          "OpenCode",
          "Odysseus"
        ],
        'Database': [
          "Firebase",
          "SQLite"
        ],
        'IDE': [
          "Android Studio",
          "VSCode",
          "WebStorm",
          "Antigravity",
          "Xcode"
        ],
        'Version Control': [
          "Git",
          "SourceTree"
        ]
      },
      'education': [
        {
          "degree": "Bachelor of Computer Science",
          "institution": "Asia Pacific College",
          "year": "2011-2015",
          "location": "Philippines, PH"
        }
      ],
      'experience': [
        {
          "title": "Mobile Application Developer",
          "company": "Accenture",
          "period": "Aug 2021 – March 2024",
          "location": "Philippines, PH",
          "responsibilities": [
            "Developed features and fixed bugs for 3 mobile applications",
            "Collaborated with cross-functional Agile teams",
            "Implemented client requirements into technical solutions",
            "Used Git for version control and team collaboration"
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
            "Resolved critical issues and implemented user stories"
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
            "Collaborated in Agile development environment"
          ]
        }
      ]
    };
  }

  void preloadData() {
    getProfileData();
  }
}
