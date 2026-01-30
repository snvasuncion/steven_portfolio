import 'package:flutter/material.dart';
import '../utility/delayed_fade_scale.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final ProfileViewModel viewModel = ProfileViewModel();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    await viewModel.fetchProfileData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    if (viewModel.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load profile data',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                viewModel.error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfileData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return DelayedFadeScale(
      delay: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DelayedFadeScale(
                delay: const Duration(milliseconds: 300),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: Color.lerp(
                      Colors.transparent, Theme.of(context).primaryColor, 0.2)!,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage: AssetImage(viewModel.getProfileImage()),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  viewModel.getFullName(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 450),
                child: Text(
                  viewModel.getJobTitle(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 500),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Experience",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (viewModel.safeExperience.isNotEmpty) ...{
                ...viewModel.safeExperience.map((exp) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp['title']?.toString() ?? 'Unknown Position',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${exp['company'] ?? 'Unknown Company'} • ${exp['period'] ?? ''}",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 8),
                        ...((exp['responsibilities'] as List<dynamic>?)?.map(
                              (responsibility) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("• "),
                                    Expanded(
                                        child: Text(responsibility.toString())),
                                  ],
                                ),
                              ),
                            ) ??
                            []),
                      ],
                    ),
                  );
                }),
              } else ...{
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'No experience data available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              },
              const SizedBox(height: 10),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 600),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Skills & Tools",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (viewModel.getAllSkills().isNotEmpty) ...{
                DelayedFadeScale(
                  delay: const Duration(milliseconds: 650),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: viewModel.getAllSkills().map((skill) {
                      return Chip(
                        label: Text(skill),
                        backgroundColor: Color.lerp(Colors.transparent,
                            Theme.of(context).primaryColor, 0.1)!,
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              } else ...{
                Text(
                  'No skills data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              },
              const SizedBox(height: 30),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 700),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Education",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (viewModel.safeEducation.isNotEmpty) ...{
                ...viewModel.safeEducation.map(
                  (edu) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edu['degree'] ?? 'Unknown Degree',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${edu['institution'] ?? ''} • ${edu['year'] ?? ''}",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              } else ...{
                Text(
                  'No education data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
