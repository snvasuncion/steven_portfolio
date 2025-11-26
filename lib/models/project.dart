class Project {
  final String title;
  final String description;
  final String imageUrl;
  final String? githubUrl;
  final String? liveUrl;
  final List<String> technologies;

  Project({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.githubUrl,
    this.liveUrl,
    required this.technologies,
  });

  // Optional: Add a factory constructor to create a Project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      githubUrl: json['githubUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      technologies: (json['technologies'] as List<dynamic>).cast<String>(),
    );
  }

  // Optional: Add a method to convert Project to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'technologies': technologies,
    };
  }
}
