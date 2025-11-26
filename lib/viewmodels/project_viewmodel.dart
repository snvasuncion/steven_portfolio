import '../models/project.dart';

class ProjectViewModel {
  List<Project> get projects => [
        Project(
          title: 'Portfolio Website',
          description:
              'Personal portfolio website built with Flutter Web, showcasing my projects and skills. '
              'Features responsive design and interactive UI components.',
          imageUrl: 'assets/images/portfolio.png',
          githubUrl: 'https://github.com/steveasuncion/portfolio',
          liveUrl: 'https://steveasuncion.dev',
          technologies: ['Flutter', 'Dart', 'BLoC'],
        ),
        // Add more projects below
        Project(
          title: 'Task Management App',
          description:
              'A cross-platform mobile application for managing tasks and projects. '
              'Includes features like task categorization, due dates, and push notifications.',
          imageUrl: 'assets/images/task_manager.png',
          githubUrl: 'https://github.com/steveasuncion/task-manager',
          technologies: ['Flutter', 'Firebase', 'Provider'],
        ),
        // Add more projects as needed
      ];

  // Get all projects
  List<Project> getAllProjects() => projects;

  // Get projects filtered by technology
  List<Project> getProjectsByTechnology(String technology) {
    return projects
        .where((project) => project.technologies.contains(technology))
        .toList();
  }

  // Get projects with live demos
  List<Project> getLiveProjects() {
    return projects.where((project) => project.liveUrl != null).toList();
  }

  // Get projects with GitHub repositories
  List<Project> getGithubProjects() {
    return projects.where((project) => project.githubUrl != null).toList();
  }

  // Get all unique technologies used across all projects
  Set<String> getAllTechnologies() {
    return projects.expand((project) => project.technologies).toSet();
  }

  // Get featured projects (you can define your own criteria)
  List<Project> getFeaturedProjects() {
    return projects.take(3).toList(); // Returns first 3 projects
  }

  // Search projects by title or description
  List<Project> searchProjects(String query) {
    query = query.toLowerCase();
    return projects
        .where((project) =>
            project.title.toLowerCase().contains(query) ||
            project.description.toLowerCase().contains(query))
        .toList();
  }

  // Sort projects by various criteria
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
