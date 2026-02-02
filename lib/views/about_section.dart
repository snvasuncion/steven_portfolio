import 'dart:convert';

import 'package:flutter/material.dart';
import '../utility/delayed_fade_scale.dart';
import '../viewmodels/about_viewmodel.dart';
import '../data/data_provider.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  final AboutViewModel viewModel = AboutViewModel();

  @override
  void initState() {
    super.initState();
    if (DataProvider().cachedData != null) {
      return;
    }

    _loadAboutData();
  }

  Future<void> _loadAboutData() async {
    await viewModel.fetchAboutData();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final cachedData = DataProvider().cachedData;
    if (cachedData != null && !viewModel.isLoading) {
      return _buildContentWithData(cachedData);
    }

    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load about data',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                    ),
              ),
              const SizedBox(height: 8),
              Text(viewModel.error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAboutData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return DelayedFadeScale(
      delay: const Duration(milliseconds: 200),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DelayedFadeScale(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'About Me',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  viewModel.safeIntro,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'What I Do',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              if (viewModel.safeWhatIDo.isNotEmpty) ...{
                ...viewModel.safeWhatIDo.asMap().entries.map((entry) {
                  int index = entry.key;
                  String task = entry.value;
                  return DelayedFadeScale(
                    delay: Duration(milliseconds: 600 + (index * 100)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text("• $task"),
                    ),
                  );
                }),
                const SizedBox(height: 32),
              } else ...{
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("No services listed"),
                ),
              },
              DelayedFadeScale(
                delay: Duration(
                    milliseconds: 600 + (viewModel.safeWhatIDo.length * 100)),
                child: Text(
                  'Highlights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              if (viewModel.safeHighlights.isNotEmpty) ...{
                DelayedFadeScale(
                  delay: Duration(
                      milliseconds: 700 + (viewModel.safeWhatIDo.length * 100)),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: viewModel.safeHighlights
                        .map((highlight) => Chip(label: Text(highlight)))
                        .toList(),
                  ),
                ),
              } else ...{
                const Text("No highlights available"),
              },
              const SizedBox(height: 32),
              DelayedFadeScale(
                delay: Duration(
                    milliseconds: 800 + (viewModel.safeWhatIDo.length * 100)),
                child: Text(
                  'Fun Fact',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              DelayedFadeScale(
                delay: Duration(
                    milliseconds: 900 + (viewModel.safeWhatIDo.length * 100)),
                child: Text(
                  viewModel.safeFunFact,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentWithData(Map<String, dynamic> data) {
    // Helper function to parse lists
    List<String> parseList(String jsonString) {
      try {
        final parsed = jsonDecode(jsonString) as List;
        return parsed.map((item) => item.toString()).toList();
      } catch (e) {
        return [];
      }
    }

    final intro = data['intro'] ?? '';
    final whatIDo = parseList(data['whatIDo'] ?? '[]');
    final highlights = parseList(data['highlights'] ?? '[]');
    final funFact = data['funFact'] ?? '';

    return DelayedFadeScale(
      delay: const Duration(milliseconds: 200),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DelayedFadeScale(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'About Me',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  intro,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 32),
              DelayedFadeScale(
                delay: const Duration(milliseconds: 500),
                child: Text(
                  'What I Do',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              if (whatIDo.isNotEmpty) ...{
                ...whatIDo.asMap().entries.map((entry) {
                  int index = entry.key;
                  String task = entry.value;
                  return DelayedFadeScale(
                    delay: Duration(milliseconds: 600 + (index * 100)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text("• $task"),
                    ),
                  );
                }),
                const SizedBox(height: 32),
              } else ...{
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text("No services listed"),
                ),
              },
              DelayedFadeScale(
                delay: Duration(milliseconds: 600 + (whatIDo.length * 100)),
                child: Text(
                  'Highlights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              if (highlights.isNotEmpty) ...{
                DelayedFadeScale(
                  delay: Duration(milliseconds: 700 + (whatIDo.length * 100)),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: highlights
                        .map((highlight) => Chip(label: Text(highlight)))
                        .toList(),
                  ),
                ),
              } else ...{
                const Text("No highlights available"),
              },
              const SizedBox(height: 32),
              DelayedFadeScale(
                delay: Duration(milliseconds: 800 + (whatIDo.length * 100)),
                child: Text(
                  'Fun Fact',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              DelayedFadeScale(
                delay: Duration(milliseconds: 900 + (whatIDo.length * 100)),
                child: Text(
                  funFact,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
