import 'package:flutter/material.dart';
import '../utility/delayed_fade_scale.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ProfileViewModel();

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
              // Profile Image
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

              // Name & Title
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

              // Experience Section
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
              
              ...viewModel.experience.asMap().entries.map((entry) {
                int index = entry.key;
                var exp = entry.value;
                return DelayedFadeScale(
                  delay: Duration(milliseconds: 550 + (index * 100)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp['title']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${exp['company']} • ${exp['period']}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 8),
                        ...((exp['responsibilities'] as List<String>).map(
                          (responsibility) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• "),
                                Expanded(child: Text(responsibility)),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 10),

              // Skills Section
              DelayedFadeScale(
                delay: Duration(milliseconds: 550 + (viewModel.experience.length * 100)),
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
              
              DelayedFadeScale(
                delay: Duration(milliseconds: 600 + (viewModel.experience.length * 100)),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: viewModel.getAllSkills().map((skill) {
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Color.lerp(
                          Colors.transparent, Theme.of(context).primaryColor, 0.1)!,
                      labelStyle: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 30),

              // Education Section
              DelayedFadeScale(
                delay: Duration(milliseconds: 650 + (viewModel.experience.length * 100)),
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
              
              ...viewModel.education.asMap().entries.map((entry) {
                int index = entry.key;
                var edu = entry.value;
                return DelayedFadeScale(
                  delay: Duration(milliseconds: 700 + (viewModel.experience.length * 100) + (index * 50)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          edu['degree']!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${edu['institution']} • ${edu['year']}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}