import 'dart:convert';
import "../models/project.dart";
import '../data/data_provider.dart';

class ProjectViewModel {
  List<Project>? _projects;
  bool isLoading = false;
  String? error;

  Future<void> fetchProjects() async {
    final cachedProjects = DataProvider().cachedProjects;
    if (cachedProjects != null && cachedProjects.isNotEmpty) {
      _projects = _parseProjectsFromData(cachedProjects);
      isLoading = false;
      return;
    }

    _projects = _parseProjectsFromData([
      {
        'id': '1',
        'title': "Custom Weather Map App",
        'description':
            "Simple weather forecasting application featuring user authentication, location-based weather search, and search history functionality. Built using MVVM architecture with comprehensive error handling for a seamless user experience. \n\nThis application was developed for a job assessment.",
        'githubUrl': "https://github.com/snvasuncion/WeatherApp",
        'technologies': '["React Native", "JavaScript", "REST API"]',
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
        'technologies': '["Flutter", "Dart", "flutter_bloc", "Google Fonts", "flutter_svg", "Shimmer", "HTTP", "WASM", "CSS3"]',
      }
    ]);
    isLoading = false;
  }

  List<Project> _parseProjectsFromData(List<dynamic> projectsData) {
    return projectsData.map((projectData) {
      List<String> technologies = [];
      if (projectData['technologies'] is String &&
          (projectData['technologies'] as String).isNotEmpty) {
        try {
          technologies =
              List<String>.from(json.decode(projectData['technologies']));
        } catch (e) {
          technologies = [];
        }
      }

      return Project(
        id: projectData['id']?.toString() ?? '',
        title: projectData['title']?.toString() ?? 'Untitled Project',
        description: projectData['description']?.toString() ??
            'No description available',
        githubUrl: projectData['githubUrl']?.toString() ?? '',
        technologies: technologies,
        liveUrl: projectData['liveUrl']?.toString(),
      );
    }).toList();
  }

  List<Project> get projects => _projects ?? [];
  List<Project> getAllProjects() => projects;

  List<Project> getProjectsByTechnology(String technology) {
    return projects
        .where((project) => project.technologies.contains(technology))
        .toList();
  }

  List<Project> getLiveProjects() {
    return projects.where((project) => project.liveUrl != null).toList();
  }

  List<Project> getGithubProjects() {
    return projects.where((project) => project.githubUrl.isNotEmpty).toList();
  }

  Set<String> getAllTechnologies() {
    return projects.expand((project) => project.technologies).toSet();
  }

  List<Project> getFeaturedProjects() {
    return projects.take(3).toList();
  }

  List<Project> searchProjects(String query) {
    query = query.toLowerCase();
    return projects
        .where((project) =>
            project.title.toLowerCase().contains(query) ||
            project.description.toLowerCase().contains(query))
        .toList();
  }

  List<Project> sortProjects({required SortCriteria criteria}) {
    final sortedProjects = List<Project>.from(projects);
    switch (criteria) {
      case SortCriteria.title:
        sortedProjects.sort((a, b) => a.title.compareTo(b.title));
      case SortCriteria.technologyCount:
        sortedProjects.sort(
            (a, b) => b.technologies.length.compareTo(a.technologies.length));
    }
    return sortedProjects;
  }
}
