import 'dart:convert';

class Project {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String githubUrl;
  final List<String> technologies;
  final String? liveUrl;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.githubUrl,
    required this.technologies,
    this.liveUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    List<String> technologies = [];
    if (json['technologies'] != null && json['technologies'].isNotEmpty) {
      technologies = List<String>.from(jsonDecode(json['technologies']));
    }
    
    return Project(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Untitled Project',
      description: json['description'] ?? 'No description available',
      imageUrl: json['imageUrl'] ?? 'assets/images/placeholder.png',
      githubUrl: json['githubUrl'] ?? '',
      technologies: technologies,
      liveUrl: json['liveUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'technologies': jsonEncode(technologies),
      'liveUrl': liveUrl,
    };
  }
}

enum SortCriteria {
  title,
  technologyCount,
}