import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steven_asuncion_portfolio/blocs/navigation_bloc.dart';
import 'package:steven_asuncion_portfolio/views/about_section.dart';
import 'package:steven_asuncion_portfolio/views/contact_section.dart';
import 'package:steven_asuncion_portfolio/views/project_section.dart';
import 'header.dart';
import 'profile_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc()..add(NavigationEvent.about),
      child: Scaffold(
        drawer: MediaQuery.of(context).size.width < 800
            ? BlocBuilder<NavigationBloc, NavigationState>(
                builder: (context, state) {
                  return Drawer(
                    child: Column(
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                          ),
                          child: const Center(
                            child: Text(
                              'Portfolio Menu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.person,
                          label: 'Profile',
                          event: NavigationEvent.profile,
                          selected: state.selectedSection ==
                              NavigationEvent.profile,
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.info,
                          label: 'About',
                          event: NavigationEvent.about,
                          selected:
                              state.selectedSection == NavigationEvent.about,
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.work,
                          label: 'Projects',
                          event: NavigationEvent.projects,
                          selected:
                              state.selectedSection == NavigationEvent.projects,
                        ),
                        _buildDrawerItem(
                          context,
                          icon: Icons.mail,
                          label: 'Contact',
                          event: NavigationEvent.contact,
                          selected:
                              state.selectedSection == NavigationEvent.contact,
                        ),
                      ],
                    ),
                  );
                },
              )
            : null,
        appBar: AppBar(
          title: const Text('My Portfolio'),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.about),
              child:
                  const Text('About', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.projects),
              child: const Text('Projects',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => BlocProvider.of<NavigationBloc>(context)
                  .add(NavigationEvent.contact),
              child: const Text('Contact',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 800;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isMobile)
                  const SizedBox(
                    width: 350,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ProfileSection(), // left remains untouched
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: constraints.maxHeight,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
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
                                    // Show Header only on desktop
                                    if (!isMobile) const Header(),
                                    
                                    BlocBuilder<NavigationBloc, NavigationState>(
                                      builder: (context, state) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // On mobile, show ProfileSection when Profile is selected
                                            if (isMobile && state.selectedSection == NavigationEvent.profile)
                                              const ProfileSection(),
                                            
                                            // For desktop, ignore Profile selection and default to About
                                            // OR show appropriate content section
                                            if (!isMobile && state.selectedSection == NavigationEvent.profile)
                                              const AboutSection(), // Fallback to About on desktop when Profile is selected
                                            if (state.selectedSection == NavigationEvent.about)
                                              const AboutSection(),
                                            if (state.selectedSection == NavigationEvent.projects)
                                              ProjectsSection(),
                                            if (state.selectedSection == NavigationEvent.contact)
                                              const ContactSection(),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Drawer item helper for consistency + highlighting
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required NavigationEvent event,
    required bool selected,
  }) {
    return ListTile(
      leading: Icon(icon,
          color: selected ? Theme.of(context).primaryColor : null),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? Theme.of(context).primaryColor : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      onTap: () {
        BlocProvider.of<NavigationBloc>(context).add(event);
        Navigator.pop(context);
      },
    );
  }
}