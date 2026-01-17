import '../models/project.dart';

class ProjectViewModel {
  List<Project> get projects => [
        Project(
          title: 'Custom Weather Map App',
          description:
              'Simple weather forecasting application featuring user authentication, location-based weather search, and search history functionality. Built using MVVM architecture with comprehensive error handling for a seamless user experience. \n\nThis application was developed for a job assessment. Details of this application is in the source code below.',
          imageUrl: 'assets/images/task_manager.png',
          githubUrl: 'https://github.com/snvasuncion/WeatherApp',
          technologies: ['React Native', 'JavaScript', 'REST API'],
        ),
      ];

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
    return projects.where((project) => project.githubUrl != null).toList();
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

enum SortCriteria {
  title,
  technologyCount,
}
