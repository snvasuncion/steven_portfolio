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
    
    // Default data if no cache
    _projects = _parseProjectsFromData([
      {
        'id': '1',
        'title': "Custom Weather Map App",
        'description':
            "Simple weather forecasting application featuring user authentication, location-based weather search, and search history functionality. Built using MVVM architecture with comprehensive error handling for a seamless user experience. \n\nThis application was developed for a job assessment.",
        'imageUrl': "assets/images/task_manager.png",
        'githubUrl': "https://github.com/snvasuncion/WeatherApp",
        'technologies': '["React Native", "JavaScript", "REST API"]',
      }
    ]);
    isLoading = false;
  }

  // ADD THIS HELPER METHOD:
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
        imageUrl: projectData['imageUrl']?.toString() ??
            'assets/images/placeholder.png',
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
