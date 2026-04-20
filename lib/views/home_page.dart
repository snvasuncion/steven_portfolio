import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:steven_asuncion_portfolio/blocs/navigation_bloc.dart';
import 'package:steven_asuncion_portfolio/views/about_section.dart';
import 'package:steven_asuncion_portfolio/views/contact_section.dart';
import 'package:steven_asuncion_portfolio/views/project_section.dart';
import 'profile_section.dart';
import '../blocs/theme_cubit.dart';

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
          floatingActionButton: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).primaryColor.withValues(alpha: 0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                  backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  tooltip:
                      isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  child: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isDesktop &&
                      state.selectedSection == NavigationEvent.about)
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
                                    child: _buildContentSection(
                                        state.selectedSection),
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

  PreferredSizeWidget _buildAppBar(
      BuildContext context, NavigationState state, bool isDesktop) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color navColor = isDark ? const Color(0xFFF2E6FF) : Colors.white;

    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isDark
                ? [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                    const Color(0xFF111827),
                  ]
                : [
                    Theme.of(context).primaryColor,
                    const Color(0xFF7E57C2),
                    const Color(0xFF9575CD),
                  ],
          ),
        ),
      ),
      title: !isDesktop
          ? GestureDetector(
              onTap: () {
                context.read<NavigationBloc>().add(NavigationEvent.about);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Shimmer.fromColors(
                  baseColor: navColor,
                  highlightColor: Colors.deepPurpleAccent[100]!,
                  child: Image.asset(
                    'assets/images/SNVWorks_Logo.png',
                    height: 38,
                    color: navColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
            )
          : null,
      actions: [
        if (isDesktop) ...[
          GestureDetector(
            onTap: () {
              context.read<NavigationBloc>().add(NavigationEvent.about);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Shimmer.fromColors(
                  baseColor: navColor,
                  highlightColor: Colors.deepPurpleAccent[100]!,
                  child: Image.asset(
                    'assets/images/SNVWorks_Logo.png',
                    height: 38,
                    color: navColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color navColor = isDark ? const Color(0xFFF2E6FF) : Colors.white;
    final Color drawerBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: drawerBg,
          child: Column(
            children: [
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.8),
                      isDark ? const Color(0xFF0F172A) : Colors.white,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future:
                            Future.delayed(const Duration(milliseconds: 350)),
                        builder: (context, snapshot) {
                          final staticImage = Image.asset(
                            'assets/images/SNVWorks_Logo_wText.png',
                            height: 100,
                            color: isDark ? navColor : Colors.white,
                            colorBlendMode: BlendMode.srcIn,
                          );

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return staticImage;
                          }

                          return Shimmer.fromColors(
                            baseColor: isDark ? navColor : Colors.white,
                            highlightColor: Colors.deepPurpleAccent[100]!,
                            child: staticImage,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'PORTFOLIO MENU',
                        style: GoogleFonts.poppins(
                          color: isDark
                              ? navColor.withValues(alpha: 0.6)
                              : Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.person_outline,
                      label: 'Profile',
                      event: NavigationEvent.profile,
                      selected:
                          state.selectedSection == NavigationEvent.profile,
                      disabled:
                          state.selectedSection == NavigationEvent.profile,
                      navColor: navColor,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline,
                      label: 'About',
                      event: NavigationEvent.about,
                      selected: state.selectedSection == NavigationEvent.about,
                      disabled: state.selectedSection == NavigationEvent.about,
                      navColor: navColor,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.grid_view_rounded,
                      label: 'Projects',
                      event: NavigationEvent.projects,
                      selected:
                          state.selectedSection == NavigationEvent.projects,
                      disabled:
                          state.selectedSection == NavigationEvent.projects,
                      navColor: navColor,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.alternate_email_rounded,
                      label: 'Contact',
                      event: NavigationEvent.contact,
                      selected:
                          state.selectedSection == NavigationEvent.contact,
                      disabled:
                          state.selectedSection == NavigationEvent.contact,
                      navColor: navColor,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  '© 2026 SNVWorks',
                  style: TextStyle(
                    color: isDark ? Colors.white24 : Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
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
    required Color navColor,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? Theme.of(context)
                  .primaryColor
                  .withValues(alpha: isDark ? 0.15 : 0.1)
              : Colors.transparent,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(
            icon,
            color: selected
                ? (isDark ? navColor : Theme.of(context).primaryColor)
                : (isDark ? Colors.white54 : Colors.grey[600]),
          ),
          title: Text(
            label,
            style: GoogleFonts.poppins(
              color: selected
                  ? (isDark ? navColor : Theme.of(context).primaryColor)
                  : (isDark ? Colors.white70 : Colors.black87),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 16,
            ),
          ),
          trailing: selected
              ? Icon(Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark ? navColor : Theme.of(context).primaryColor)
              : null,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: disabled
              ? null
              : () {
                  context.read<NavigationBloc>().add(event);
                  Navigator.pop(context);
                },
        ),
      ),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color navColor = isDark ? const Color(0xFFF2E6FF) : Colors.white;

    return GestureDetector(
      onTapDown:
          widget.isDisabled ? null : (_) => setState(() => _scale = 0.95),
      onTapUp: widget.isDisabled ? null : (_) => setState(() => _scale = 1.0),
      onTapCancel:
          widget.isDisabled ? null : () => setState(() => _scale = 1.0),
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
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: widget.isDisabled
                    ? null
                    : () => context.read<NavigationBloc>().add(widget.event),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: TextStyle(
                    color: widget.isSelected
                        ? navColor
                        : navColor.withValues(alpha: 0.7),
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.normal,
                    letterSpacing: 0.5,
                  ),
                  child: Text(widget.label),
                ),
              ),
              if (widget.isSelected)
                Container(
                  height: 2,
                  width: 20,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color:
                        isDark ? Theme.of(context).primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
