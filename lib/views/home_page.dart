import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steven_asuncion_portfolio/blocs/navigation_bloc.dart';
import 'package:steven_asuncion_portfolio/views/about_section.dart';
import 'package:steven_asuncion_portfolio/views/contact_section.dart';
import 'package:steven_asuncion_portfolio/views/project_section.dart';
import 'profile_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          drawer: isDesktop ? null : _buildDrawer(context),
          appBar: _buildAppBar(context, state, isDesktop),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isDesktop && state.selectedSection == NavigationEvent.about)
                    const SizedBox(
                      width: 350,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: ProfileSection(),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.08),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                children: [
                                  Container(
                                    key: ValueKey(state.selectedSection),
                                    child: _buildContentSection(state.selectedSection),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, NavigationState state, bool isDesktop) {
    return AppBar(
      title: const Text('My Portfolio'),
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      actions: [
        if (isDesktop) ...[
          _buildAppBarButton(
            context: context,
            label: 'About',
            event: NavigationEvent.about,
            isSelected: state.selectedSection == NavigationEvent.about,
            isDisabled: state.selectedSection == NavigationEvent.about,
          ),
          _buildAppBarButton(
            context: context,
            label: 'Projects',
            event: NavigationEvent.projects,
            isSelected: state.selectedSection == NavigationEvent.projects,
            isDisabled: state.selectedSection == NavigationEvent.projects,
          ),
          _buildAppBarButton(
            context: context,
            label: 'Contact',
            event: NavigationEvent.contact,
            isSelected: state.selectedSection == NavigationEvent.contact,
            isDisabled: state.selectedSection == NavigationEvent.contact,
          ),
          const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildAppBarButton({
    required BuildContext context,
    required String label,
    required NavigationEvent event,
    required bool isSelected,
    required bool isDisabled,
  }) {
    return AnimatedAppBarButton(
      label: label,
      event: event,
      isSelected: isSelected,
      isDisabled: isDisabled,
    );
  }

  Widget? _buildDrawer(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Drawer(
          child: Column(
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Portfolio Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildDrawerItem(
                context,
                icon: Icons.person,
                label: 'Profile',
                event: NavigationEvent.profile,
                selected: state.selectedSection == NavigationEvent.profile,
                disabled: state.selectedSection == NavigationEvent.profile,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.info,
                label: 'About',
                event: NavigationEvent.about,
                selected: state.selectedSection == NavigationEvent.about,
                disabled: state.selectedSection == NavigationEvent.about,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.work,
                label: 'Projects',
                event: NavigationEvent.projects,
                selected: state.selectedSection == NavigationEvent.projects,
                disabled: state.selectedSection == NavigationEvent.projects,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.mail,
                label: 'Contact',
                event: NavigationEvent.contact,
                selected: state.selectedSection == NavigationEvent.contact,
                disabled: state.selectedSection == NavigationEvent.contact,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required NavigationEvent event,
    required bool selected,
    required bool disabled,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Theme.of(context).primaryColor : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      enabled: !disabled,
      onTap: disabled 
          ? null 
          : () {
              context.read<NavigationBloc>().add(event);
              Navigator.pop(context);
            },
    );
  }

  Widget _buildContentSection(NavigationEvent selectedSection) {
    switch (selectedSection) {
      case NavigationEvent.about:
        return const AboutSection();
      case NavigationEvent.projects:
        return const ProjectsSection();
      case NavigationEvent.contact:
        return const ContactSection();
      case NavigationEvent.profile:
        return const ProfileSection();
    }
  }
}

class AnimatedAppBarButton extends StatefulWidget {
  final String label;
  final NavigationEvent event;
  final bool isSelected;
  final bool isDisabled;

  const AnimatedAppBarButton({
    super.key,
    required this.label,
    required this.event,
    required this.isSelected,
    required this.isDisabled,
  });

  @override
  State<AnimatedAppBarButton> createState() => _AnimatedAppBarButtonState();
}

class _AnimatedAppBarButtonState extends State<AnimatedAppBarButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isDisabled ? null : (_) => setState(() => _scale = 0.95),
      onTapUp: widget.isDisabled ? null : (_) => setState(() => _scale = 1.0),
      onTapCancel: widget.isDisabled ? null : () => setState(() => _scale = 1.0),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 100),
        tween: Tween(begin: 1.0, end: _scale),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: widget.isDisabled ? 1.0 : scale,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.isSelected
                ? Color.lerp(Colors.transparent, Theme.of(context).primaryColor, 0.2)
                : Colors.transparent,
          ),
          child: TextButton(
            onPressed: widget.isDisabled 
                ? null 
                : () => context.read<NavigationBloc>().add(widget.event),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 150),
              style: TextStyle(
                color: widget.isSelected ? Colors.yellow : Colors.white,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}