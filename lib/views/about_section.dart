import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utility/delayed_fade_scale.dart';
import '../viewmodels/about_viewmodel.dart';
import '../widgets/hover_interactive_container.dart';

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
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.all(24),
        child: _buildContent(),
      ),
    );
  }
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAboutHeader(),
            const SizedBox(height: 40),
            _buildSkillsGrid(),
            const SizedBox(height: 48),
            _buildWhatIDo(),
            const SizedBox(height: 48),
            _buildHighlights(),
            const SizedBox(height: 48),
            _buildFunFact(),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutHeader() {
    return DelayedFadeScale(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            viewModel.safeIntro,
            style: GoogleFonts.openSans(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsGrid() {
    return DelayedFadeScale(
      delay: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Technical Expertise',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: viewModel.skills.map((skill) => _buildSkillCard(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillCard(Skill skill) {
    return SizedBox(
      width: 160,
      child: HoverInteractiveContainer(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(skill.icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(
                skill.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                skill.level,
                style: GoogleFonts.openSans(
                  fontSize: 11,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatIDo() {
    return DelayedFadeScale(
      delay: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What I Specialized In',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          ...viewModel.safeWhatIDo.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        size: 18, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.openSans(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildHighlights() {
    return DelayedFadeScale(
      delay: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Highlights',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: viewModel.safeHighlights
                .map((h) => Chip(
                      label: Text(h, style: GoogleFonts.openSans(fontSize: 12)),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
                      side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFact() {
    return DelayedFadeScale(
      delay: const Duration(milliseconds: 1200),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Fun Fact',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              viewModel.safeFunFact,
              style: GoogleFonts.openSans(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
