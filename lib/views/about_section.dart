import 'package:flutter/material.dart';
import '../utility/delayed_fade_scale.dart';
import '../viewmodels/about_viewmodel.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = AboutViewModel();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        padding: const EdgeInsets.all(24),
        child: DelayedFadeScale(
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
                      viewModel.intro,
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
                  
                  ...viewModel.whatIDo.asMap().entries.map((entry) {
                    int index = entry.key;
                    String task = entry.value;
                    return DelayedFadeScale(
                      delay: Duration(milliseconds: 600 + (index * 100)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text("• $task"),
                      ),
                    );
                  }).toList(),
                  
                  const SizedBox(height: 32),

                  // Highlights
                  DelayedFadeScale(
                    delay: Duration(milliseconds: 600 + (viewModel.whatIDo.length * 100)),
                    child: Text(
                      'Highlights',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DelayedFadeScale(
                    delay: Duration(milliseconds: 700 + (viewModel.whatIDo.length * 100)),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: viewModel.highlights
                          .map((highlight) => Chip(label: Text(highlight)))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Fun Fact
                  DelayedFadeScale(
                    delay: Duration(milliseconds: 800 + (viewModel.whatIDo.length * 100)),
                    child: Text(
                      'Fun Fact',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DelayedFadeScale(
                    delay: Duration(milliseconds: 900 + (viewModel.whatIDo.length * 100)),
                    child: Text(
                      viewModel.funFact,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}