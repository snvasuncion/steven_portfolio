import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/project_viewmodel.dart';
import '../models/project.dart';
import '../utility/delayed_fade_scale.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final ProjectViewModel _viewModel = ProjectViewModel();

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    await _viewModel.fetchProjects();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            if (_viewModel.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_viewModel.error != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load projects',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _viewModel.error!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProjects,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_viewModel.projects.isEmpty)
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
              )
            else
              ..._viewModel.projects.asMap().entries.map((entry) {
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            DelayedFadeScale(
                              delay: const Duration(milliseconds: 150),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (project.githubUrl.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 2,
                                        ),
                                        onPressed: () =>
                                            _launchUrl(project.githubUrl),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.code, size: 20),
                                            const SizedBox(width: 8),
                                            Text(
                                              'GitHub',
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (project.liveUrl != null &&
                                      project.liveUrl!.isNotEmpty)
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      onPressed: () =>
                                          _launchUrl(project.liveUrl!),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.open_in_browser,
                                              size: 20),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Live Demo',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }
}
