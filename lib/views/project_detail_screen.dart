import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;
  final Future<void> Function(String) onLaunchUrl;

  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.onLaunchUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          project.title,
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Image
            if (project.imageUrl.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(project.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 24),
              ),
            
            Text(
              project.title,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              project.description,
              style: GoogleFonts.openSans(
                fontSize: 16,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Technologies Used',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: project.technologies
                  .map((tech) => Chip(label: Text(tech)))
                  .toList(),
            ),
            const SizedBox(height: 32),
            if (project.githubUrl != null || project.liveUrl != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (project.githubUrl != null)
                    ElevatedButton.icon(
                      onPressed: () => onLaunchUrl(project.githubUrl!),
                      icon: const Icon(Icons.code),
                      label: const Text('View Code'),
                    ),
                  const SizedBox(width: 16),
                  if (project.liveUrl != null)
                    ElevatedButton.icon(
                      onPressed: () => onLaunchUrl(project.liveUrl!),
                      icon: const Icon(Icons.launch),
                      label: const Text('Live Demo'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}