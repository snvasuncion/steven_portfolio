import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/project_viewmodel.dart';
import '../models/project.dart';
import '../utility/delayed_fade_scale.dart';

class ProjectsSection extends StatelessWidget {
  final ProjectViewModel _viewModel = ProjectViewModel();

  ProjectsSection({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = _viewModel.projects;

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title with animation
            DelayedFadeScale(
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Projects',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Projects with staggered animations
            if (projects.isNotEmpty)
              ...projects.asMap().entries.map((entry) {
                int index = entry.key;
                Project project = entry.value;
                return DelayedFadeScale(
                  delay: Duration(milliseconds: 300 + (index * 150)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project Title
                            DelayedFadeScale(
                              delay: const Duration(milliseconds: 0),
                              child: Text(
                                project.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Project Description
                            DelayedFadeScale(
                              delay: const Duration(milliseconds: 50),
                              child: Text(
                                project.description,
                                style: GoogleFonts.openSans(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Technologies
                            DelayedFadeScale(
                              delay: const Duration(milliseconds: 100),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: project.technologies
                                    .map((tech) => Chip(
                                          label: Text(tech),
                                          backgroundColor: Color.lerp(
                                            Colors.transparent,
                                            Theme.of(context).primaryColor,
                                            0.1,
                                          )!,
                                          labelStyle: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // GitHub Button
                            if (project.githubUrl != null)
                              DelayedFadeScale(
                                delay: const Duration(milliseconds: 150),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: () => _launchUrl(project.githubUrl!),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.code, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          'View on GitHub',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()
            else
              const DelayedFadeScale(
                delay: Duration(milliseconds: 300),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text('No projects to display'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}