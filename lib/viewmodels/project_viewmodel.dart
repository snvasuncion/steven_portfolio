import 'dart:convert';
import 'package:http/http.dart' as http;
import "../models/project.dart";

class ProjectViewModel {
  final String apiUrl =
      "https://69790a31cd4fe130e3db0374.mockapi.io/portfolio/v1/projects";

  List<Project>? _projects;
  bool isLoading = false;
  String? error;

  Future<void> fetchProjects() async {
    try {
      isLoading = true;
      error = null;

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch projects: ${response.statusCode}');
      }

      List<dynamic> projectsData = jsonDecode(response.body);

      _projects = projectsData.map((projectData) {
        List<String> technologies = [];
        if (projectData['technologies'] is String &&
            (projectData['technologies'] as String).isNotEmpty) {
          technologies =
              List<String>.from(jsonDecode(projectData['technologies']));
        }

        return Project(
          id: projectData['id']?.toString() ?? '',
          title: projectData['title']?.toString() ?? 'Untitled Project',
          description: projectData['description']?.toString() ??
              'No description available',
          imageUrl: projectData['imageUrl']?.toString() ??
              'assets/images/placeholder.png',
          githubUrl: projectData['githubUrl']?.toString() ?? '',
          technologies: technologies,
          liveUrl: projectData['liveUrl']?.toString(),
        );
      }).toList();
    } catch (e) {
      error = 'Error loading projects: $e';

      _projects = [
        Project(
          id: '1',
          title: "Custom Weather Map App",
          description:
              "Simple weather forecasting application featuring user authentication, location-based weather search, and search history functionality. Built using MVVM architecture with comprehensive error handling for a seamless user experience. \n\nThis application was developed for a job assessment. Details of this application is in the source code below.",
          imageUrl: "assets/images/task_manager.png",
          githubUrl: "https://github.com/snvasuncion/WeatherApp",
          technologies: ["React Native", "JavaScript", "REST API"],
        ),
      ];
    } finally {
      isLoading = false;
    }
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
